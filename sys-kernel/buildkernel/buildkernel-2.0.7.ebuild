# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility for building and installing EFI secure boot kernels under Gentoo Linux."
HOMEPAGE="https://github.com/JohnFlowerful/buildkernel"
SRC_URI="https://github.com/JohnFlowerful/buildkernel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="plymouth"
RESTRICT="mirror"

DEPEND="
	>=sys-apps/gptfdisk-0.8.8
	>=sys-fs/cryptsetup-1.6.2
	>=app-shells/bash-4.2:*
	>=virtual/linux-sources-3
"
RDEPEND="
	>=sys-libs/ncurses-5.9-r2
	>=app-crypt/sbsigntools-0.6-r1
	plymouth? ( >=sys-boot/plymouth-22.02.122[pango] )
	>=sys-kernel/dracut-050-r2
	>=sys-boot/efibootmgr-18
	>=sys-apps/debianutils-4.9.1[installkernel(+)]
	sys-kernel/installkernel[-dracut]
"

# ebuild function overrides
src_prepare() {
	# if the plymouth use flag not set, set script variable accordingly
	if ! use plymouth; then
		elog "plymouth USE flag not selected - patching script accordingly."
		sed -e 's@USE_PLYMOUTH=true@USE_PLYMOUTH=false@g' -i "${PN}" || \
			die "Failed to patch script to reflect omitted plymouth USE flag."
	fi
	eapply_user
}

src_install() {
	dosbin "${PN}"
	insinto "/etc"
	doins "${PN}.conf"
	doman "${PN}.8"
	doman "${PN}.conf.5"
}

pkg_preinst() {
	if [ -e "${ROOT}/etc/${PN}.conf" ]; then
		# don't overwrite buildkernel.conf, user already has one,
		# and we don't want to force an unneeded dispatch-conf
		elog "/etc/${PN}.conf already exists, not overwriting."
		# install an identical copy; this is safer than deleting from
		# the pre-install image
		cp "${ROOT}/etc/${PN}.conf" "${D}/etc/${PN}.conf"
	else
		# attempt to set the LUKS and EFI partition ids automatically
		# in the config file (in ${D}) if this can be done unambiguously
		set_luks_partuuid_if_exactly_one_found
		set_efi_partuuid_if_exactly_one_found_on_usb
	fi
}

pkg_postinst() {
	elog "Be sure to check the CRYPTPARTUUID and EFIPARTUUID variables are"
	elog "set correctly in /etc/buildkernel.conf, and also ensure that you have an"
	elog "appropriate value for KEYMAP in this file, before running buildkernel."
}

# helper functions
set_luks_partuuid_if_exactly_one_found() {
	# checks all partitions for LUKS and, if exactly one is found, will set that
	# for the CRYPTPARTUUID in buildkernel.conf
	# if no candidate or multiple candidates found, print a warning
	local BKCONFPATH REALBKCONFPATH PARTUUIDDEVDIR
	BKCONFPATH="$(sed 's#//*#/#g' <<< "${D}/etc/buildkernel.conf")"
	REALBKCONFPATH="$(sed 's#//*#/#g' <<< "${ROOT}/etc/buildkernel.conf")"
	PARTUUIDDEVDIR="$(sed 's#//*#/#g' <<< "${ROOT}/dev/disk/by-partuuid")"
	if ! grep -q '^[[:space:]]*#[[:space:]]*CRYPTPARTUUID=' "${BKCONFPATH}"; then
		elog "CRYPTPARTUUID is already set in ${BKCONFPATH}, leaving as is"
		return
	fi
	elog "Attempting to find singleton LUKS partition for CRYPTPARTUUID..."
	local NEXTPART CANDIDATE=""
	shopt -s nullglob
	for NEXTPART in "${PARTUUIDDEVDIR}"/*; do
		if [ -e "${NEXTPART}" ]; then
			if cryptsetup isLuks "${NEXTPART}"; then
				if [ -z "${CANDIDATE}" ]; then
					CANDIDATE="${NEXTPART,,}"
				else
					ewarn " Multiple candidates for LUKS partition found!"
					ewarn " Please set CRYPTPARTUUID manually in ${REALBKCONFPATH}"
					shopt -u nullglob
					return
				fi
			fi
		fi
	done
	shopt -u nullglob
	if [ -n "${CANDIDATE}" ]; then
		elog " Found exactly one candidate: $(basename "${CANDIDATE}")"
		elog " (which is $(readlink --canonicalize "${CANDIDATE}"))"
		elog " Setting this for CRYPTPARTUUID in ${REALBKCONFPATH}"
		sed -i "s@^[[:space:]]*#[[:space:]]*CRYPTPARTUUID=.*@CRYPTPARTUUID=\"$(basename "${CANDIDATE}")\"@" "${BKCONFPATH}"
	else
		ewarn " No LUKS partition candidates found!"
		ewarn " Please set CRYPTPARTUUID manually in ${REALBKCONFPATH}"
	fi
}

set_efi_partuuid_if_exactly_one_found_on_usb() {
	# checks all partitions on USB devices only; if exactly one EFI system
	# partition is found, will set that for EFIPARTUUID in buildkernel.conf
	local BKCONFPATH REALBKCONFPATH PARTUUIDDEVDIR DISKIDDEVDIR
	BKCONFPATH="$(sed 's#//*#/#g' <<< "${D}/etc/buildkernel.conf")"
	REALBKCONFPATH="$(sed 's#//*#/#g' <<< "${ROOT}/etc/buildkernel.conf")"
	PARTUUIDDEVDIR="$(sed 's#//*#/#g' <<< "${ROOT}/dev/disk/by-partuuid")"
	DISKIDDEVDIR="$(sed 's#//*#/#g' <<< "${ROOT}/dev/disk/by-id")"
	if ! grep -q '^[[:space:]]*#[[:space:]]*EFIPARTUUID=' "${BKCONFPATH}"; then
		ewarn "EFIPARTUUID is already set in ${BKCONFPATH}, leaving as is"
		return
	fi
	elog "Attempting to find singleton USB EFI system partition for EFIPARTUUID..."
	local NEXTPART CANDIDATE=""
	declare -A ISUSBPART
	# lookup all USB partitions, and store
	local NEXTID
	for NEXTID in "${DISKIDDEVDIR}/usb-"*"-part"*[[:digit:]]; do
		if [ -e "${NEXTID}" ]; then
			# remember this
			local NEXTCANONPART
			NEXTCANONPART="$(readlink --canonicalize "${NEXTID}")" # e.g. /dev/sda3
			ISUSBPART["${NEXTCANONPART}"]="1"
		fi
	done
	shopt -s nullglob
	for NEXTPART in "${PARTUUIDDEVDIR}"/*; do
		if [ -e "${NEXTPART}" ]; then
			local PARTNAME
			PARTNAME="$(readlink --canonicalize "${NEXTPART}")" # e.g. /dev/sda3
			if [[ "${ISUSBPART[${PARTNAME}]-0}" == "1" ]]; then
				local DEVNAME PARTNUM
				DEVNAME="${PARTNAME%%[[:digit:]]*}"			   # e.g. /dev/sda
				PARTNUM="${PARTNAME##*[^[:digit:]]}"			  # e.g. 3
				# stat returns device type in hex only
				if (sgdisk --info "${PARTNUM}" "${DEVNAME}" | grep -qi 'EFI System'); then
					if [ -z "${CANDIDATE}" ]; then
						CANDIDATE="${NEXTPART,,}"
					else
						ewarn " Multiple candidates for EFI system partition found!"
						ewarn " Please set EFIPARTUUID manually in ${REALBKCONFPATH}"
						shopt -u nullglob
						return
					fi
				fi
			fi
		fi
	done
	shopt -u nullglob
	if [ -n "${CANDIDATE}" ]; then
		elog " Found exactly one candidate: $(basename "${CANDIDATE}")"
		elog " (which is $(readlink --canonicalize "${CANDIDATE}"))"
		elog " Setting this for EFIPARTUUID in ${REALBKCONFPATH}"
		sed -i "s@^[[:space:]]*#[[:space:]]*EFIPARTUUID=.*@EFIPARTUUID=\"$(basename "${CANDIDATE}")\"@" "${BKCONFPATH}"
	else
		ewarn " No USB EFI system partition candidates found!"
		ewarn " Please set EFIPARTUUID manually in ${REALBKCONFPATH}"
	fi
}
