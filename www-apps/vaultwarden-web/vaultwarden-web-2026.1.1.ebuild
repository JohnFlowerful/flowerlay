# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

#MY_PV=${PV%c}

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

SRC_URI="
	https://github.com/vaultwarden/vw_web_builds/archive/refs/heads/v${PV}.zip
	https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-deps.tar.gz
"

S="${WORKDIR}/vw_web_builds-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=">=net-libs/nodejs-22"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"
# this package is really useless without vaultwarden, it cannot be run
# standalone, so pull in vaultwarden to run it
PDEPEND="app-admin/vaultwarden[web]"

NPM_FLAGS=("--legacy-peer-deps")
NPM_BUILD_FLAGS=("--workspace" "apps/web")
NPM_BUILD_SCRIPT="build:oss:selfhost:prod"
export ELECTRON_SKIP_BINARY_DOWNLOAD=1

src_install() {
	insinto "/usr/share/webapps/${PN}"
	doins -r apps/web/build/*

	einstalldocs
}
