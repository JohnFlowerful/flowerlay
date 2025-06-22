# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# qmk_firmware version in which the udev rules file was last modified
QMK_FIRMWARE_VER="0.27.3"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature pypi udev

DESCRIPTION="A program to help users work with QMK"
HOMEPAGE="
	https://qmk.fm/
	https://github.com/qmk/qmk_cli
	https://pypi.org/project/qmk/
"
SRC_URI="
	$(pypi_sdist_url)
	https://raw.githubusercontent.com/qmk/qmk_firmware/${QMK_FIRMWARE_VER}/util/udev/50-qmk.rules
		-> ${PN}-udev-${QMK_FIRMWARE_VER}.rules
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# no tests provided by upstream
RESTRICT="test"

RDEPEND="
	app-arch/unzip
	app-arch/zip
	app-mobilephone/dfu-util
	dev-embedded/avrdude
	dev-embedded/dfu-programmer
	dev-libs/hidapi
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/dotty-dict[${PYTHON_USEDEP}]
	dev-python/hidapi[${PYTHON_USEDEP}]
	dev-python/hjson[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4[${PYTHON_USEDEP}]
	>=dev-python/milc-1.9.0[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-vcs/git
	net-misc/wget
	sys-apps/hwloc
	sys-devel/crossdev
"

# upstream won't switch to the dev-python/hidapi package nor will they vendor the
# "unmaintained" module
# see https://github.com/qmk/qmk_cli/issues/82 for the discussion
#
# provide a patch to remove pyhidapi dependency and use dev-python/hidapi instead
PATCHES=("${FILESDIR}/${PN}-1.1.5_linux-hidapi.patch")

src_prepare() {
	sed -rz -e 's/,\n.+"wheel"//' -i "pyproject.toml" || die

	distutils-r1_src_prepare
}

src_install() {
	udev_newrules "${DISTDIR}/${PN}-udev-${QMK_FIRMWARE_VER}.rules" 50-qmk.rules

	distutils-r1_src_install
}

pkg_postinst() {
	optfeature_header
	optfeature "ChibiOS build support" llvm-core/clang

	[[ ! -x /usr/bin/avr-gcc ]] && ewarn "Missing avr-gcc; you need to 'crossdev -s4 avr'"
	[[ ! -x /usr/bin/arm-none-eabi-gcc ]] && ewarn "Missing arm-none-eabi-gcc; you need to 'crossdev -s4 arm-none-eabi'"

	udev_reload
}

pkg_postrm() {
	udev_reload
}
