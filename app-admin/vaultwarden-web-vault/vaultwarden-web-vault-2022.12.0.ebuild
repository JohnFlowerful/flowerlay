# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

EGIT_REPO_URI="https://github.com/bitwarden/clients.git"
EGIT_COMMIT="web-v${PV}"

# vaultwarden patch
#MY_PATCHV=$(ver_cut 1-2).1
MY_PATCHV="${PV}"
SRC_URI="
	https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/patches/v${MY_PATCHV}.patch -> ${P}.patch
	https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/resources/icon-dark.png
	https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/resources/icon-white.png
	https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/resources/logo-dark@2x.png
	https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/resources/logo-white@2x.png
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

src_prepare() {
	# new repo for bitwarden clients includes desktop versions as well...
	# removing electron will suffice for now
	eapply "${FILESDIR}/${P}-remove_electron.patch"

	# apply vaultwarden patches
	cp -vf "${DISTDIR}/logo-dark@2x.png" "${S}/apps/web/src/images/logo-dark@2x.png" || die
	cp -vf "${DISTDIR}/logo-white@2x.png" "${S}/apps/web/src/images/logo-white@2x.png" || die
	cp -vf "${DISTDIR}/icon-white.png" "${S}/apps/web/src/images/icon-white.png" || die
	eapply "${DISTDIR}/${P}.patch"

	default
}

src_configure() {
	npm config set nodedir "/usr/include/node" || die
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
