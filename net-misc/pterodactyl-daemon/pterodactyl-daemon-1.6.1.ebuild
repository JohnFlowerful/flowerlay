# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="The server control plane for Pterodactyl Panel."
HOMEPAGE="https://pterodactyl.io/"

SRC_URI="
	https://github.com/pterodactyl/wings/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="amd64"

ACCT_DEPEND="
	acct-group/pterodactyl
	acct-user/pterodactyl
"
DEPEND="
	${ACCT_DEPEND}
	app-containers/docker
"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/wings-${PV}"

src_compile() {
	MY_COMMIT="$(zcat ${DISTDIR}/${P}.tar.gz | git get-tar-commit-id)";
	MY_DATE=$(date "+%F-%T")
	go build \
		-o wings \
		-trimpath \
		-ldflags="-X 'system.Version=${PV} (commit: ${MY_COMMIT}, date: ${MY_DATE})'" || die
}

src_install() {
	dobin "${S}/wings"

	keepdir /etc/pterodactyl-daemon
	keepdir /var/lib/pterodactyl-daemon
	keepdir /var/log/pterodactyl-daemon

	doinitd "${FILESDIR}/pterodactyl-daemon"

	fowners -R pterodactyl:pterodactyl \
		/etc/pterodactyl-daemon \
		/var/lib/pterodactyl-daemon \
		/var/log/pterodactyl-daemon
}
