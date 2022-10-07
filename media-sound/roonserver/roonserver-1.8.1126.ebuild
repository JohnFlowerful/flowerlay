# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A music management and listening solution"
HOMEPAGE="https://roonlabs.com/"
MY_PN="RoonServer"
MY_PV_MAJOR=$(ver_cut 1)
MY_PV_MINOR=$(ver_cut 2)
MY_PV_BUILD=$(ver_cut 3)
SRC_URI="http://download.roonlabs.com/builds/${MY_PN}Legacy_linuxx64_${MY_PV_MAJOR}00${MY_PV_MINOR}0${MY_PV_BUILD}.tar.bz2"

LICENSE="Roon"
SLOT="0"
IUSE="alsa samba system-dotnet"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

ACCT_DEPEND="
	acct-group/roon
	acct-user/roon
"
DEPEND="
	${ACCT_DEPEND}
	dev-libs/icu
	>=sys-libs/glibc-2.14
"
RDEPEND="
	${DEPEND}
	alsa? ( media-libs/alsa-lib )
	samba? ( net-fs/cifs-utils )
	system-dotnet? ( dev-dotnet/dotnet-sdk-bin:6.0 )
	dev-util/lttng-ust
	media-video/ffmpeg
"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	# bundled files appear to be a standard dotnet core distribution
	if use system-dotnet; then
		rm -rf "${S}"/RoonDotnet/* || die
		MY_DOTNET=$(command -v dotnet) || die
		ln -s "${MY_DOTNET}" "${S}"/RoonDotnet/ || die
	fi

	default
}

src_install() {
	newinitd "${FILESDIR}"/roonserver.init ${PN}
	newconfd "${FILESDIR}"/roonserver.conf ${PN}
	systemd_newunit "${FILESDIR}"/roonserver.service ${PN}.service

	keepdir /var/lib/roon
	fowners roon:roon /var/lib/roon

	# the doins helper function doesn't preserve perms so we need to copy manually
	mkdir ${D}/opt || die
	cp -r ${S} ${D}/opt/ || die

	dosym /opt/${MY_PN}/RoonDotnet/dotnet /opt/${MY_PN}/RoonDotnet/RAATServer
	dosym /opt/${MY_PN}/RoonDotnet/dotnet /opt/${MY_PN}/RoonDotnet/RoonAppliance
	dosym /opt/${MY_PN}/RoonDotnet/dotnet /opt/${MY_PN}/RoonDotnet/RoonServer
}

pkg_postinst() {
	CIFS_PERM=$(stat -c '%a' /sbin/mount.cifs)
	CONFD_DIR="/etc/conf.d"
	UNIT_DIR=$(systemd_get_systemunitdir)
	if use samba && \
	! [[ $CIFS_PERM =~ ^47[[:digit:]][[:digit:]] ]] && \
	! [[ $(grep 'USER="root"' "${CONFD_DIR}"/${PN}) ]] && \
	! [[ $(grep "User=root" "${UNIT_DIR}"/${PN}.service) ]]; then
		ewarn "Roon uses the superuser command 'mount.cifs' to access network locations."
		ewarn "While this ebuild restricts Roon to a regular user account, it is still possible"
		ewarn "to allow Roon to use 'mount.cifs' with setuid: 'chmod u+s /sbin/mount.cifs'."
		ewarn "Otherwise running Roon as root is required to access network locations."
	fi
}
