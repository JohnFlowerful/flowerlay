# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Go binary license checker"
HOMEPAGE="https://github.com/uw-labs/lichen"
SRC_URI="
	https://github.com/uw-labs/lichen/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
"

LICENSE="MIT Apache-2.0 BSD BSD-2 MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror"

src_compile() {
	go build -v -work -x -o "${PN}" || die
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
