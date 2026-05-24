# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 udev

DESCRIPTION="CLI tool and Python library to configure SteelSeries gaming mice"
HOMEPAGE="
	https://github.com/flozz/rivalcfg
	https://pypi.org/project/rivalcfg/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/flozz/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/hidapi-0.14.0[${PYTHON_USEDEP}]"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
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
