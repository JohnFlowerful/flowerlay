# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Configure SteelSeries gaming mice"
HOMEPAGE="https://github.com/flozz/rivalcfg"
SRC_URI="http://github.com/flozz/rivalcfg/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="${PYTHON_DEPS}"
DEPEND="
	${COMMON_DEPEND}
	>=dev-python/hidapi-0.7.99[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

src_prepare() {
	sed -i 's/import hid/import hidapi as hid/' "${S}/${PN}/debug.py" || die
	sed -i 's/import hid/import hidapi as hid/' "${S}/${PN}/usbhid.py" || die
	default
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	einfo "Run rivalcfg --update-udev as root to generate Udev rules"
}
