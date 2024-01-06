# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

MY_PN="py-${PN}"

inherit distutils-r1

DESCRIPTION="Spinners for terminals"
HOMEPAGE="
	https://github.com/manrajgrover/py-spinners
	https://pypi.org/project/spinners/
"
# the pypi archive is missing test files and upstream doesn't tag releases on github...
SPINNERS_COMMIT="76116a679c8e704f41a9b1f5b9838639a1b74b95"
SRC_URI="
	https://github.com/manrajgrover/${MY_PN}/archive/${SPINNERS_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

S="${WORKDIR}/${MY_PN}-${SPINNERS_COMMIT}"

src_prepare() {
	# fix deprecation warnings
	sed -e 's/description-file/description_file/g' -i "setup.cfg" || die

	sed -e 's/assertEquals/assertEqual/' -i "tests/test_spinners.py" || die

	distutils-r1_src_prepare
}
