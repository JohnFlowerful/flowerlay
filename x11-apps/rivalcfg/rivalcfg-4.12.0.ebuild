# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi udev

DESCRIPTION="CLI tool and Python library to configure SteelSeries gaming mice"
HOMEPAGE="
	https://github.com/flozz/rivalcfg
	https://pypi.org/project/rivalcfg/
"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/hidapi-0.7.99[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's/import hid/import hidapi as hid/' -i "${PN}/debug.py" || die
	sed -e 's/import hid/import hidapi as hid/' -i "${PN}/usbhid.py" || die

	sed -e "/^RULES_FILE_PATH = /s|\".*\"|\"$(get_udevdir)/rules.d/99-steelseries-rival.rules\"|" \
		-i "${PN}/udev.py" || die

	distutils-r1_src_prepare
}

python_install() {
	einfo "Generating udev rules"
	udev_newrules - "99-steelseries-rival.rules" <<<"$("${BUILD_DIR}/install/usr/bin/${PN}" --print-udev)"

	distutils-r1_python_install
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
