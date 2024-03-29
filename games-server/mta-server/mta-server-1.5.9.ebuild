# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="multitheftauto_linux_x64"
MY_P="${MY_PN}-${PV}"

inherit tmpfiles

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
RESTRICT="bindist mirror"

RDEPEND="
	=dev-libs/openssl-1.1*
	sys-libs/ncurses-compat
	sys-libs/readline
"

DOCS=( LICENSE NOTICE README )

INS_DIR="/opt/${MY_PN}"
QA_PREBUILT="${INS_DIR}/mta-server64 ${INS_DIR}/x64/*"
QA_EXECSTACK="${INS_DIR}/mta-server64"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# copy the required files from ${DISTDIR} so we can install/modify them later
	if use sockets; then
		mkdir x64/modules || die
		cp "${DISTDIR}/ml_sockets.so" x64/modules || die
	fi

	default
}

src_install() {
	exeinto "${INS_DIR}"
	doexe mta-server64

	insinto "${INS_DIR}"
	doins -r "x64/"

	if use daemon; then
		newinitd "${FILESDIR}/${PN}-r1.initd" "${PN}"
		newconfd "${FILESDIR}/${PN}.confd" "${PN}"
		newtmpfiles - "${PN}.conf" <<-EOF
			d /run/${PN} 0755 root root
		EOF
	fi

	if use baseconfig; then
		dodoc -r "${WORKDIR}/baseconfig"
		docompress -x "/usr/share/doc/${PF}/baseconfig"
	fi

	einstalldocs
}

pkg_postinst() {
	if use daemon; then
		tmpfiles_process "${PN}.conf"
	fi
}
