# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
HOMEPAGE="https://github.com/emersion/hydroxide"

SRC_URI="
	https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
"

LICENSE="ISC BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="daemon"
# no tests provided
RESTRICT="mirror test"

RDEPEND="
	daemon? (
		acct-group/hydroxide
		acct-user/hydroxide
	)
"

# patch to fix "Login temporarily not permitted" errors from protonmail api
PATCHES=(
	"${FILESDIR}/user_agent.patch"
)

src_prepare() {
	if use daemon; then
		PATCHES+=( "${FILESDIR}/system_service.patch" )
	fi

	default
}

src_compile() {
	go build ./cmd/hydroxide || die
}

src_install() {
	dobin hydroxide

	if use daemon; then
		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
		newconfd "${FILESDIR}/${PN}.confd" "${PN}"

		keepdir "/var/lib/${PN}"
		fowners hydroxide:hydroxide "/var/lib/${PN}"
	fi

	einstalldocs
}
