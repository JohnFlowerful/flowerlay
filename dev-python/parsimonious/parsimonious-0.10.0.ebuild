# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Parsimonious aims to be the fastest arbitrary-lookahead parser written in pure Python"
HOMEPAGE="
	https://github.com/erikrose/parsimonious
	https://pypi.org/project/parsimonious/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/erikrose/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-python/regex-2022.3.15[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
