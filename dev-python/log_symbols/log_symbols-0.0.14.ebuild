# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="py-${PN//_/-}"

DESCRIPTION="Colored symbols for various log levels for Python"
HOMEPAGE="https://github.com/manrajgrover/py-log-symbols"
# the pypi archive is missing test files and upstream doesn't tag releases on github...
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
LOG_SYMBOLS_COMMIT="eb527ec951e3d02c828efdb56e9f78e364c109b2"
SRC_URI="https://github.com/manrajgrover/${MY_PN}/archive/${LOG_SYMBOLS_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]"

distutils_enable_tests nose

S="${WORKDIR}/${MY_PN}-${LOG_SYMBOLS_COMMIT}"

src_prepare() {
	sed -i -e 's/description-file/description_file/g' "${S}/setup.cfg" || die
	default
}
