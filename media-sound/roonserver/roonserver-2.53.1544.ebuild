# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="RoonServer"

DESCRIPTION="A music management and listening solution"
HOMEPAGE="https://roonlabs.com/"

SRC_URI="https://download.roonlabs.com/builds/${MY_PN}_linuxx64_$(ver_cut 1)0$(ver_cut 2)0$(ver_cut 3).tar.bz2"

S="${WORKDIR}/${MY_PN}"

LICENSE="Roon"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa samba system-dotnet"
RESTRICT="bindist mirror strip"

RDEPEND="
	acct-group/roon
	acct-user/roon
	dev-libs/icu
	dev-util/lttng-ust
	media-video/ffmpeg
	alsa? ( media-libs/alsa-lib )
	samba? ( net-fs/cifs-utils )
	system-dotnet? ( dev-dotnet/dotnet-sdk-bin:6.0 )
"

src_prepare() {
	# bundled files appear to be a standard dotnet core distribution
	if use system-dotnet; then
		rm -rf "RoonDotnet/"* || die
	fi

	default
}

src_install() {
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "/var/lib/roon"
	fowners roon:roon "/var/lib/roon"

	# the doins helper function doesn't preserve perms so we need to copy manually
	mkdir "${D}/opt" || die
	cp -r "${S}" "${D}/opt/" || die

	if use system-dotnet; then
		local dotnet=$(command -v dotnet) || die
		dosym "${dotnet}" "/opt/${MY_PN}/RoonDotnet/dotnet" || die
	fi

	# these symlinks should be created when roon is started for the first time,
	# but this ebuild runs roon as a regular user which doesn't have access to
	# installation files
	dosym dotnet "/opt/${MY_PN}/RoonDotnet/RAATServer"
	dosym dotnet "/opt/${MY_PN}/RoonDotnet/RoonAppliance"
	dosym dotnet "/opt/${MY_PN}/RoonDotnet/RoonServer"

}

pkg_postinst() {
	CIFS_PERM=$(stat -c '%a' /sbin/mount.cifs)
	CONFD_DIR="/etc/conf.d"
	if use samba && \
	! [[ ${CIFS_PERM} =~ ^47[[:digit:]][[:digit:]] ]] && \
	! [[ $(grep 'USER="root"' "${CONFD_DIR}/${PN}") ]]; then
		ewarn "Roon uses the superuser command 'mount.cifs' to access network locations."
		ewarn "While this ebuild restricts Roon to a regular user account, it is still possible"
		ewarn "to allow Roon to use 'mount.cifs' with setuid."
		ewarn "Otherwise running Roon as root is required to access network locations."
	fi
}
