# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A small program that udev uses to identify QMK keyboards "
HOMEPAGE="https://qmk.fm/"
SRC_URI="https://github.com/qmk/qmk_udev/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

src_install() {
	make PREFIX="/" DESTDIR=${D} install
}