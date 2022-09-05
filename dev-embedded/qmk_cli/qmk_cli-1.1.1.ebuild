# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A program to help users work with QMK"
HOMEPAGE="https://qmk.fm/"
SRC_URI="https://github.com/qmk/qmk_cli/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="chibios"

RDEPEND="
	app-arch/unzip
	app-arch/zip
	app-mobilephone/dfu-util
	dev-embedded/avrdude
	dev-embedded/dfu-programmer
	dev-embedded/qmk_udev
	dev-libs/hidapi
	dev-python/appdirs
	dev-python/argcomplete
	dev-python/colorama
	dev-python/dotty_dict
	dev-python/hid
	dev-python/hjson
	>=dev-python/jsonschema-4
	>=dev-python/milc-1.4.2
	dev-python/pygments
	dev-python/pyserial
	dev-python/pyusb
	dev-vcs/git
	net-misc/wget
	sys-apps/hwloc
	chibios? ( sys-devel/clang )
	sys-devel/crossdev
"

RESTRICT="test"

src_prepare() {
	default
	sed -rz -i 's/,\n.+"wheel"//' "${S}/pyproject.toml" || die
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to 'crossdev -s4 avr'"
	[ ! -x /usr/bin/arm-none-eabi-gcc ] && ewarn "Missing arm-none-eabi-gcc; you need to 'crossdev -s4 arm-none-eabi'"
}
