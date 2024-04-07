# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

# vaultwarden patch
#MY_PATCHV=$(ver_cut 1-2).0
MY_PATCHV="${PV}"

BW_WEB_BUILDS="${WORKDIR}/bw_web_builds-${PV}"
BW_RESOURCES="${BW_WEB_BUILDS}/resources/src"

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

SRC_URI="
	https://github.com/bitwarden/clients/archive/web-v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dani-garcia/bw_web_builds/archive/v${PV}.tar.gz -> ${P}-resources.tar.gz
	https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-deps.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=">=net-libs/nodejs-18"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

NPM_FLAGS=("--legacy-peer-deps")
NPM_BUILD_FLAGS=("--workspace" "apps/web")
NPM_BUILD_SCRIPT="build:oss:selfhost:prod"
export ELECTRON_SKIP_BINARY_DOWNLOAD=1

PATCHES=(
	# apply vaultwarden patches
	# see https://github.com/dani-garcia/bw_web_builds/blob/master/scripts/apply_patches.sh
	"${BW_WEB_BUILDS}/patches/v${MY_PATCHV}.patch"
)

S="${WORKDIR}/clients-web-v${PV}"

src_prepare() {
	# copy vaultwarden assets
	cp -fr "${BW_RESOURCES}/"* apps/web/src/ || die

	default
}

src_install() {
	insinto "/usr/share/${PN}/htdocs"
	doins -r apps/web/build/*

	einstalldocs
}
