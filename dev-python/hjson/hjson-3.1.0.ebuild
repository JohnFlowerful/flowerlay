# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="${PN}-py"

DESCRIPTION="Hjson for Python"
HOMEPAGE="https://github.com/hjson/hjson-py"
# the pypi archive is missing test asset files and upstream tags releases inconsistently...
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
HJSON_PY_COMMIT="1687b811fcbbc54b5ac71cfbaa99f805e406fbcb"
SRC_URI="https://github.com/${PN}/${MY_PN}/archive/${HJSON_PY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="AFL-2.1 MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests unittest

S="${WORKDIR}/${MY_PN}-${HJSON_PY_COMMIT}"
