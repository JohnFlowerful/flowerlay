# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Opinionated Batteries-Included Python 3 CLI Framework."
HOMEPAGE="
	https://github.com/clueboard/milc
	https://pypi.org/project/milc/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/clueboard/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Clueboard"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/halo[${PYTHON_USEDEP}]
	dev-python/spinners[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/semver-3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
