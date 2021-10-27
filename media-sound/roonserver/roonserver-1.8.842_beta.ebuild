# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A music management and listening solution"
HOMEPAGE="https://roonlabs.com/"
MY_PV_MAJOR=$(ver_cut 1)
MY_PV_MINOR=$(ver_cut 2)
MY_PV_BUILD=$(ver_cut 3)
MY_PV_SUFFIX=$(ver_cut 4)
SRC_URI="RoonServer_linuxx64_${MY_PV_MAJOR}00${MY_PV_MINOR}00${MY_PV_BUILD}_${MY_PV_SUFFIX}.tar.bz2"

LICENSE="Roon"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="fetch strip"

ACCT_DEPEND="
	acct-group/roon
	acct-user/roon
"
DEPEND="
    ${ACCT_DEPEND}
	dev-libs/icu
    media-video/ffmpeg
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/RoonServer"

pkg_nofetch() {
	einfo
	einfo "This package requires Roon private beta access. You can find the"
	einfo "tarball in the private beta section: https://community.roonlabs.com/c/private-beta"
	einfo
	einfo "Please download ${SRC_URI}"
	einfo "and place it in your distfiles directory"
	einfo
}

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

	executables=$(file_to_prepended_string executables_beta "/opt/RoonServer")
	fperms +x ${executables}

	dosym /opt/RoonServer/RoonDotnet/dotnet /opt/RoonServer/RoonDotnet/RAATServer
	dosym /opt/RoonServer/RoonDotnet/dotnet /opt/RoonServer/RoonDotnet/RoonAppliance
	dosym /opt/RoonServer/RoonDotnet/dotnet /opt/RoonServer/RoonDotnet/RoonServer
}
