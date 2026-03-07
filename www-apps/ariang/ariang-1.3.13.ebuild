# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="AriaNg"

inherit npm

DESCRIPTION="A modern web frontend making aria2 easier to use"
HOMEPAGE="https://ariang.mayswind.net/"

SRC_URI="
	https://github.com/mayswind/AriaNg/archive/refs/tags/${PV}.zip
	https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-deps.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=">=net-libs/nodejs-22"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"
PDEPEND="net-misc/aria2"

NPM_FLAGS=("--legacy-peer-deps")
# silence harmless ENOTCACHED warning (with a hammer)
NPM_FLAGS+=("--loglevel=error")
NPM_BUILD_SCRIPT="build"

src_configure() {
	npm_src_configure

	# unsure why this link isn't created when installing gulp
	mkdir "${S}/node_modules/.bin" || die
	ln -s "${S}/node_modules/gulp/bin/gulp.js" "${S}/node_modules/.bin/gulp" || die
}

src_install() {
	insinto "/usr/share/webapps/${MY_PN}"
	doins -r dist/*

	einstalldocs
}
