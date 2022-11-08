# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Automagic shell tab completion for Python CLI applications"
HOMEPAGE="https://github.com/iterative/shtab"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's/--cov=shtab --cov-report=term-missing --cov-report=xml//' setup.cfg || die
	distutils-r1_src_prepare
}
