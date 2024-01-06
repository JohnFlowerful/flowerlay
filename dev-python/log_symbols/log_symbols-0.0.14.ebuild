# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

MY_PN="py-${PN//_/-}"

inherit distutils-r1

DESCRIPTION="Colored symbols for various log levels for Python"
HOMEPAGE="
	https://github.com/manrajgrover/py-log-symbols
	https://pypi.org/project/log-symbols/
"
# the pypi archive is missing test files and upstream doesn't tag releases on github...
LOG_SYMBOLS_COMMIT="eb527ec951e3d02c828efdb56e9f78e364c109b2"
SRC_URI="
	https://github.com/manrajgrover/${MY_PN}/archive/${LOG_SYMBOLS_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

S="${WORKDIR}/${MY_PN}-${LOG_SYMBOLS_COMMIT}"

src_prepare() {
	# fix deprecation warnings
	sed -e 's/description-file/description_file/' -i "setup.cfg" || die

	distutils-r1_src_prepare
}
