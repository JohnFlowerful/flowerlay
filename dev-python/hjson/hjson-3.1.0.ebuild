# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

MY_PN="${PN}-py"

inherit distutils-r1

DESCRIPTION="Hjson for Python"
HOMEPAGE="
	https://github.com/hjson/hjson-py
	https://pypi.org/project/hjson/
"
# the pypi archive is missing test asset files and upstream tags releases inconsistently...
HJSON_PY_COMMIT="1687b811fcbbc54b5ac71cfbaa99f805e406fbcb"
SRC_URI="
	https://github.com/${PN}/${MY_PN}/archive/${HJSON_PY_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="AFL-2.1 MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

S="${WORKDIR}/${MY_PN}-${HJSON_PY_COMMIT}"
