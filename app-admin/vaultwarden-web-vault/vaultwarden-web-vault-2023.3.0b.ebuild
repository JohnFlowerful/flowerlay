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
	BW_RESOURCES="${BW_WEB_BUILDS}/resources"

	cp -vf "${BW_RESOURCES}/logo-dark@2x.png" "${S}/apps/web/src/images/logo-dark@2x.png" || die
	cp -vf "${BW_RESOURCES}/logo-white@2x.png" "${S}/apps/web/src/images/logo-white@2x.png" || die
	cp -vf "${BW_RESOURCES}/icon-white.png" "${S}/apps/web/src/images/icon-white.png" || die

	cp -vf "${BW_RESOURCES}/android-chrome-192x192.png" "${S}/apps/web/src/images/icons/android-chrome-192x192.png" || die
	cp -vf "${BW_RESOURCES}/android-chrome-512x512.png" "${S}/apps/web/src/images/icons/android-chrome-512x512.png" || die
	cp -vf "${BW_RESOURCES}/apple-touch-icon.png" "${S}/apps/web/src/images/icons/apple-touch-icon.png" || die
	cp -vf "${BW_RESOURCES}/favicon-16x16.png" "${S}/apps/web/src/images/icons/favicon-16x16.png" || die
	cp -vf "${BW_RESOURCES}/favicon-32x32.png" "${S}/apps/web/src/images/icons/favicon-32x32.png" || die
	cp -vf "${BW_RESOURCES}/mstile-150x150.png" "${S}/apps/web/src/images/icons/mstile-150x150.png" || die
	cp -vf "${BW_RESOURCES}/safari-pinned-tab.svg" "${S}/apps/web/src/images/icons/safari-pinned-tab.svg" || die
	cp -vf "${BW_RESOURCES}/favicon.ico" "${S}/apps/web/src/favicon.ico" || die

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
