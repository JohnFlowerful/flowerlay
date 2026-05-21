# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

#MY_PV=${PV%c}

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

SRC_URI="
	https://github.com/vaultwarden/vw_web_builds/archive/refs/heads/v${PV}.tar.gz
		-> ${P}.tar.gz
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
NPM_BUILD_SCRIPT="dist:oss:selfhost"
export ELECTRON_SKIP_BINARY_DOWNLOAD=1

src_prepare() {
	default

	# upstream's lockfile is out of sync [1]. this package is not used by the
	# web client
	# https://github.com/bitwarden/clients/pull/20480
	sed -i 's|"@napi-rs/cli": "3.5.1"|"@napi-rs/cli": "3.2.0"|' package-lock.json || die
}

src_install() {
	insinto "/usr/share/webapps/${PN}"
	doins -r apps/web/build/*
}
