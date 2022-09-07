# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="A third-party ProtonMail bridge serving SMTP and IMAP"
HOMEPAGE="https://github.com/ljanyst/peroxide"

SRC_URI="
	https://github.com/ljanyst/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
"

LICENSE="Apache-2.0 ISC BSD BSD-2 MIT MPL-2.0 Unlicense"
SLOT="0"
IUSE="daemon"
KEYWORDS="~amd64"

RESTRICT="mirror"

ACCT_DEPEND="
	acct-group/peroxide
	acct-user/peroxide
"
RDEPEND="daemon? ( ${ACCT_DEPEND} )"

src_prepare() {
	# patch away the default config location for a user oriented one
	eapply "${FILESDIR}/user_config.patch"

	if use daemon; then
		sed -i -r 's|~/.config/peroxide/|/var/lib/peroxide/|' config.example.yaml || die
		sed -i -r 's|~/.cache/peroxide|/var/lib/peroxide/cache|' config.example.yaml || die
	fi

	eapply_user
}

src_compile() {
	go build ./cmd/peroxide || die
	go build ./cmd/peroxide-cfg || die
}

src_install() {
	dobin peroxide
	dobin peroxide-cfg
	dodoc "README.md"
	dodoc "LICENSE"
	dodoc "config.exmaple.yaml"

	if use daemon; then
		systemd_newunit "${FILESDIR}/${PN}.service" "${PN}.service"

		insinto /etc
		newins config.example.yaml ${PN}.yaml

		keepdir "/var/lib/peroxide"
	fi

	newinitd "${FILESDIR}/${PN}.init" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}

	systemd_douserunit "${FILESDIR}/${PN}_user.service"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"
}

pkg_preinst() {
	if use daemon; then
		sed -i -r '/USER=/s|".+|"peroxide"|' "${D}/etc/conf.d/${PN}" || die
	fi
}
