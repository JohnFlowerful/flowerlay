# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A music management and listening solution"
HOMEPAGE="https://roonlabs.com/"
MY_PV_MAJOR=$(ver_cut 1)
MY_PV_MINOR=$(ver_cut 2)
MY_PV_BUILD=$(ver_cut 3)
SRC_URI="http://download.roonlabs.com/builds/RoonServer_linuxx64_${MY_PV_MAJOR}00${MY_PV_MINOR}00${MY_PV_BUILD}.tar.bz2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

ACCT_DEPEND="
	acct-group/roon
	acct-user/roon
"
DEPEND="
    ${ACCT_DEPEND}
    media-video/ffmpeg
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/RoonServer"

src_install() {
	newinitd "${FILESDIR}"/init roonserver
	newconfd "${FILESDIR}"/conf roonserver
	systemd_newunit "${FILESDIR}"/roonserver.service roonserver.service

	keepdir /var/lib/roon
	fowners roon:roon /var/lib/roon

    insinto /opt/RoonServer
    doins -r *
}
