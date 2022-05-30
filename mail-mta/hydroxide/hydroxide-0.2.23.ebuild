# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
HOMEPAGE="https://github.com/emersion/hydroxide"

SRC_URI="
	https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
"

LICENSE="ISC BSD MIT"
SLOT="0"
IUSE="daemon"
KEYWORDS="~amd64"

RESTRICT="mirror"

ACCT_DEPEND="
	acct-group/hydroxide
	acct-user/hydroxide
"
RDEPEND="daemon? ( ${ACCT_DEPEND} )"

src_prepare() {
	if use daemon; then
		eapply "${FILESDIR}/system_service.patch"
	fi
	eapply_user
}

src_compile() {
	go build ./cmd/hydroxide || die
}

src_install() {
	dobin hydroxide
	dodoc "README.md"
	dodoc "LICENSE"

	if use daemon; then
		systemd_newunit "${FILESDIR}/${PN}.service" "${PN}.service"
	fi

	newinitd "${FILESDIR}/${PN}.init" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}

	systemd_douserunit "${FILESDIR}/${PN}_user.service"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"
}

pkg_preinst() {
	if use daemon; then
		sed -i -r '/USER=/s|".+|"hydroxide"|' "${D}/etc/conf.d/${PN}" || die
	fi
}
