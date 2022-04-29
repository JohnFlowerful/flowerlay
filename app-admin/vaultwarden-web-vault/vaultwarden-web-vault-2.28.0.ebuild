# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

EGIT_REPO_URI="https://github.com/bitwarden/web.git"
EGIT_COMMIT="v${PV}"

# vaultwarden patch
SRC_URI="https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/patches/v${PV}.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=net-libs/nodejs-16.13.1[npm]"

RESTRICT="mirror network-sandbox"

src_prepare() {
	eapply "${DISTDIR}/v${PV}.patch"
	eapply_user

	# make sure the package.json provided doesn't try to update submodules again
	sed -i -r "s/npm run sub:init//" "${S}/package.json" || die

	npm ci --legacy-peer-deps --omit=optional
}

src_compile() {
	npm audit fix --legacy-peer-deps

	npm run build:oss:selfhost:prod
}

src_install() {
	insinto /usr/share/vaultwarden-web-vault/htdocs
	doins -r build/*
}