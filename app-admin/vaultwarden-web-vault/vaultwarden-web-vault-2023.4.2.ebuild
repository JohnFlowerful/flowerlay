# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# vaultwarden patch
MY_PATCHV=$(ver_cut 1-2).0
#MY_PATCHV="${PV}"

BW_WEB_BUILDS="${WORKDIR}/bw_web_builds-${PV}"
BW_RESOURCES="${BW_WEB_BUILDS}/resources/src"

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

SRC_URI="
	https://github.com/bitwarden/clients/archive/web-v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dani-garcia/bw_web_builds/archive/v${PV}.tar.gz -> ${P}-resources.tar.gz
	https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-cache.tar.xz
	https://dandelion.ilypetals.net/dist/nodejs/${P}-remove_electron.patch
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=">=net-libs/nodejs-16[npm]"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

PATCHES=(
	# new repo for bitwarden clients includes desktop versions as well...
	# removing electron will suffice for now
	"${DISTDIR}/${P}-remove_electron.patch"

	# apply vaultwarden patches
	# see https://github.com/dani-garcia/bw_web_builds/blob/master/scripts/apply_patches.sh
	"${BW_WEB_BUILDS}/patches/v${MY_PATCHV}.patch"
)

S="${WORKDIR}/clients-web-v${PV}"

src_prepare() {
	# copy vaultwarden assets
	cp -vfr "${BW_RESOURCES}/"* apps/web/src/  || die

	default
}

src_configure() {
	export npm_config_nodedir="/usr/include/node"
	npm clean-install --omit=optional --offline --cache "${WORKDIR}/npm-cache" || die
}

src_compile() {
	pushd apps/web &>/dev/null || die
		npm run build:oss:selfhost:prod || die
	popd &>/dev/null || die
}

src_install() {
	insinto "/usr/share/${PN}/htdocs"
	doins -r apps/web/build/*

	einstalldocs
}
