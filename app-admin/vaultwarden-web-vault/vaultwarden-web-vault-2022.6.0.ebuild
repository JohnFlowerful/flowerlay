# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

EGIT_REPO_URI="https://github.com/bitwarden/clients.git"
EGIT_COMMIT="web-v${PV}"

# vaultwarden patch
#MY_PATCHV=$(ver_cut 1-2).0
MY_PATCHV="${PV}"
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

src_prepare() {
	# we're patching in an update to change sha1 to sha512 for this version.
	# run 'npm update' and diff package-lock.json to get the patch.
	# only required due to cache misses (integrity check failures) while offline
	eapply "${FILESDIR}/${P}-sha1_to_sha512.patch"

	eapply "${DISTDIR}/${P}.patch"

	default
}

src_configure() {
	npm clean-install --omit=optional --offline --cache "${WORKDIR}/npm-cache" || die
}

src_compile() {
	pushd apps/web
	npm run build:oss:selfhost:prod
	popd
}

src_install() {
	insinto /usr/share/vaultwarden-web-vault/htdocs
	doins -r apps/web/build/*
}
