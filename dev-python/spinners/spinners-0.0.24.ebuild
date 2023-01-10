# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="py-${PN}"

DESCRIPTION="Spinners for terminals"
HOMEPAGE="https://github.com/manrajgrover/py-spinners"
# the pypi archive is missing test files and upstream doesn't tag releases on github...
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SPINNERS_COMMIT="76116a679c8e704f41a9b1f5b9838639a1b74b95"
SRC_URI="https://github.com/manrajgrover/${MY_PN}/archive/${SPINNERS_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests nose

S="${WORKDIR}/${MY_PN}-${SPINNERS_COMMIT}"

src_prepare() {
	sed -i -e 's/description-file/description_file/g' "${S}/setup.cfg" || die
	default
}
