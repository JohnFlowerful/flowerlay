# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

EGIT_REPO_URI="https://github.com/bitwarden/web.git"
EGIT_COMMIT="v${PV}"

# vaultwarden patch
MY_PATCHV=$(ver_cut 1-2).0
SRC_URI="
	https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${MY_PATCHV}/patches/v${MY_PATCHV}.patch -> ${P}.patch
	https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-cache.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="=net-libs/nodejs-16*[npm]"

RESTRICT="mirror"

src_unpack() {
	unpack "${P}-npm-cache.tar.xz"
	git-r3_src_unpack
}

src_configure() {
	eapply "${DISTDIR}/${P}.patch"
	eapply_user

	# make sure the package.json provided doesn't try to update submodules again
	sed -i -r 's/npm run sub:init//' "${S}/package.json" || die

	npm clean-install --legacy-peer-deps --omit=optional --cache "${WORKDIR}/npm-cache" || die
}

src_compile() {
	npm run build:oss:selfhost:prod
}

src_install() {
	insinto /usr/share/vaultwarden-web-vault/htdocs
	doins -r build/*
}
