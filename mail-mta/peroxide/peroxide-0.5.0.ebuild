# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A third-party ProtonMail bridge serving SMTP and IMAP"
HOMEPAGE="https://github.com/ljanyst/peroxide"

SRC_URI="
	https://github.com/ljanyst/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
"

LICENSE="Apache-2.0 ISC BSD BSD-2 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="daemon"
RESTRICT="mirror"

RDEPEND="
	daemon? (
		acct-group/peroxide
		acct-user/peroxide
	)
"

DOCS=( config.example.yaml README.md )

PATCHES=(
	"${FILESDIR}/user_config.patch"
)

src_prepare() {
	default

	if use daemon; then
		sed -r \
			-e "s|~/.config/peroxide/|/var/lib/${PN}/|" \
			-e "s|~/.cache/peroxide|/var/lib/${PN}/cache|" \
			-i "config.example.yaml" || die
	fi
}

src_compile() {
	go build ./cmd/peroxide || die
	go build ./cmd/peroxide-cfg || die
}

src_install() {
	dobin peroxide peroxide-cfg

	if use daemon; then
		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
		newconfd "${FILESDIR}/${PN}.confd" "${PN}"

		insinto /etc
		newins config.example.yaml "${PN}.yaml"

		keepdir "/var/lib/${PN}"
		fowners peroxide:peroxide "/var/lib/${PN}"
	fi

	einstalldocs
}
