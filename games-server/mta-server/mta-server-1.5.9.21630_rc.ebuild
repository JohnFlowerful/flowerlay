# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles

MY_PN="multitheftauto_linux_x64"
MY_PV="$(ver_cut 1-3)-rc-$(ver_cut 4)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Server files for a Grand Theft Auto multiplayer mod"
HOMEPAGE="https://multitheftauto.com/"
SRC_URI="
	https://nightly.multitheftauto.com/${MY_P}.tar.gz
	baseconfig? ( https://linux.multitheftauto.com/dl/baseconfig.tar.gz )
	sockets? ( https://nightly.multitheftauto.com/files/modules/64/ml_sockets.so )
"

LICENSE="GPL-3"
SLOT="0"
IUSE="baseconfig daemon sockets"
KEYWORDS="~amd64"

RDEPEND="
	=dev-libs/openssl-1.1*
	sys-libs/ncurses-compat
	sys-libs/readline
"

RESTRICT="bindist mirror"

INS_DIR="/opt/${MY_PN}"
QA_PREBUILT="${INS_DIR}/mta-server64 ${INS_DIR}/x64/*"
QA_EXECSTACK="${INS_DIR}/mta-server64"

S="${WORKDIR}"

src_prepare() {
	default

	# copy the required files from ${FILESDIR} and ${DISTDIR} so we can
	# modify/install them later
	cp "${FILESDIR}/${PN}_tmpfiles.conf" ${S} || die

	if use sockets; then
		cp "${DISTDIR}/ml_sockets.so" "${S}" || die
	fi
}

src_configure() {
	sed -i "s/{{PN}}/${PN}/" "${S}/${PN}_tmpfiles.conf" || die
}

src_install() {
	pushd "${MY_P}" || die
		local files="x64"
		insinto "${INS_DIR}"
		doins -r ${files}

		exeinto "${INS_DIR}"
		doexe mta-server64

		dodoc LICENSE NOTICE README
	popd || die

	if use daemon; then
		newinitd "${FILESDIR}/${PN}.init" ${PN}
		newconfd "${FILESDIR}/${PN}.conf" ${PN}
		newtmpfiles "${PN}_tmpfiles.conf" ${PN}.conf
	fi

	if use baseconfig; then
		dodoc -r baseconfig
		docompress -x /usr/share/doc/${PF}/baseconfig
	fi

	if use sockets; then
		insinto "${INS_DIR}/x64/modules"
		doins "ml_sockets.so"
	fi
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
