# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

EGIT_REPO_URI="https://github.com/bitwarden/web.git"
EGIT_COMMIT="v${PV}"
# jslib's commit requires manual attention (possible upstream rebase?). update as required
EGIT_OVERRIDE_COMMIT_BITWARDEN_JSLIB="1f0127966e85aa29f9e50144de9b2a03b00de5d4"

SRC_URI="https://raw.githubusercontent.com/dani-garcia/bw_web_builds/v${PV}/patches/v${PV}.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=net-libs/nodejs-14.17[npm]"

src_prepare() {
    eapply "${DISTDIR}/v${PV}.patch"
    eapply_user

    # make sure the package.json provided doesn't try to update submodules again
    sed -i -r "s/npm run sub:init//" "${S}/package.json" || die

    npm install
}

src_compile() {
    npm audit fix
    npm run dist
}

src_install() {
    insinto /usr/share/vaultwarden-web-vault/htdocs
    doins -r build/*
}