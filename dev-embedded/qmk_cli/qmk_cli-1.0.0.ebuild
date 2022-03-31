# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

DESCRIPTION="A program to help users work with QMK"
HOMEPAGE="https://qmk.fm/"
SRC_URI="https://github.com/qmk/qmk_cli/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="chibios"

BDEPEND="
	dev-python/build"
DEPEND="
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
	>=dev-python/jsonschema-3
	>=dev-python/milc-1.4.2
	dev-python/pygments
	dev-python/pyusb
	dev-vcs/git
	net-misc/wget
	sys-apps/hwloc
	chibios? ( sys-devel/clang )
	sys-devel/crossdev"

src_compile() {
	python -m build --wheel --skip-dependency-check --no-isolation
}

src_install() {
	python -m installer --destdir="${D}" dist/*.whl
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to 'crossdev -s4 avr'"
	[ ! -x /usr/bin/arm-none-eabi-gcc ] && ewarn "Missing arm-none-eabi-gcc; you need to 'crossdev -s4 arm-none-eabi'"
}