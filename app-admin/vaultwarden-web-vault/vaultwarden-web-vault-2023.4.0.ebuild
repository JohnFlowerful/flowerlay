# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

# vaultwarden patch
#MY_PATCHV=$(ver_cut 1-2).1
MY_PV=$(ver_cut 1-3)
MY_P="${PN}-${MY_PV}"
MY_PATCHV="${MY_PV}"
#MY_PATCHV="${PV}"

EGIT_REPO_URI="https://github.com/bitwarden/clients.git"
EGIT_COMMIT="web-v${MY_PV}"

SRC_URI="
	https://github.com/dani-garcia/bw_web_builds/archive/v${PV}.tar.gz -> ${MY_P}-resources.tar.gz
	https://dandelion.ilypetals.net/dist/nodejs/${MY_P}-npm-cache.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="=net-libs/nodejs-16*[npm]"

RESTRICT="mirror"

src_unpack() {
	unpack "${MY_P}-resources.tar.gz"
	unpack "${MY_P}-npm-cache.tar.xz"
	git-r3_src_unpack
}

src_prepare() {
	# new repo for bitwarden clients includes desktop versions as well...
	# removing electron will suffice for now
	eapply "${FILESDIR}/${MY_P}-remove_electron.patch"

	# apply vaultwarden patches
	# see https://github.com/dani-garcia/bw_web_builds/blob/master/scripts/apply_patches.sh
	BW_WEB_BUILDS="${WORKDIR}/bw_web_builds-${MY_PV}"
	BW_RESOURCES="${BW_WEB_BUILDS}/resources/src"

	cp -vfr "${BW_RESOURCES}/"* "${S}/apps/web/src/" || die

	eapply "${BW_WEB_BUILDS}/patches/v${MY_PATCHV}.patch"

	default
}

src_configure() {
	export npm_config_nodedir="/usr/include/node"
	npm clean-install --omit=optional --offline --cache "${WORKDIR}/npm-cache" || die
}

src_compile() {
	pushd apps/web || die
		npm run build:oss:selfhost:prod || die
	popd || die
}

src_install() {
	insinto /usr/share/vaultwarden-web-vault/htdocs
	doins -r apps/web/build/*
}
