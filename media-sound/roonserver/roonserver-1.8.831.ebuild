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

LICENSE="Roon"
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

# 1:file 2:prepend_string
file_to_prepended_string() {
	list=$(<"${FILESDIR}"/${1})
	list=($list)
	list=("${list[@]/#/${2}'/'}")
	printf -v list "%s " "${list[@]}"
	echo $list
}

src_install() {
	newinitd "${FILESDIR}"/init roonserver
	newconfd "${FILESDIR}"/conf roonserver
	systemd_newunit "${FILESDIR}"/roonserver.service roonserver.service

	keepdir /var/lib/roon
	fowners roon:roon /var/lib/roon

    insinto /opt/RoonServer
    doins -r *

	executables=$(file_to_prepended_string executables "/opt/RoonServer")
	fperms +x ${executables}

	dosym /opt/RoonServer/RoonMono/bin/mono-sgen /opt/RoonServer/RoonMono/bin/RAATServer
	dosym /opt/RoonServer/RoonMono/bin/mono-sgen /opt/RoonServer/RoonMono/bin/RoonAppliance
	dosym /opt/RoonServer/RoonMono/bin/mono-sgen /opt/RoonServer/RoonMono/bin/RoonServer
}
