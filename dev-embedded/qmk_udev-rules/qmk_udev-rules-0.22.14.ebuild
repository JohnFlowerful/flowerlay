# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="udev rules for qmk supported keyboards in bootloader mode"
HOMEPAGE="
	https://qmk.fm/
	https://github.com/qmk/qmk_firmware/
"
SRC_URI="
	https://raw.githubusercontent.com/qmk/qmk_firmware/${PV}/util/udev/50-qmk.rules
		-> ${P}.rules
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}"

src_prepare() {
	cp "${DISTDIR}/${P}.rules" 50-qmk.rules || die

	default
}

src_install() {
	udev_dorules 50-qmk.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
