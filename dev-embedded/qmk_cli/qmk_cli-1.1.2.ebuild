# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A program to help users work with QMK"
HOMEPAGE="
	https://qmk.fm/
	https://github.com/qmk/qmk_cli
	https://pypi.org/project/qmk/
"

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
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/dotty_dict[${PYTHON_USEDEP}]
	dev-python/hid[${PYTHON_USEDEP}]
	dev-python/hjson[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4[${PYTHON_USEDEP}]
	>=dev-python/milc-1.4.2[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-vcs/git
	net-misc/wget
	sys-apps/hwloc
	chibios? ( sys-devel/clang )
	sys-devel/crossdev
"

# no tests provided by upstream
RESTRICT="test"

src_prepare() {
	default
	sed -rz -i 's/,\n.+"wheel"//' "${S}/pyproject.toml" || die
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to 'crossdev -s4 avr'"
	[ ! -x /usr/bin/arm-none-eabi-gcc ] && ewarn "Missing arm-none-eabi-gcc; you need to 'crossdev -s4 arm-none-eabi'"
}
