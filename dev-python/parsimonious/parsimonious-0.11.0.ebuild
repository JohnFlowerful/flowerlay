# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

PARSIMONIOUS_COMMIT="eb79639859a9697a86c0992a045174a8856b5fb0"

inherit distutils-r1

DESCRIPTION="An arbitrary-lookahead parser written in pure Python"
HOMEPAGE="
	https://github.com/erikrose/parsimonious
	https://pypi.org/project/parsimonious/
"
SRC_URI="
	https://github.com/erikrose/${PN}/archive/${PARSIMONIOUS_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/${PN}-${PARSIMONIOUS_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-python/regex-2022.3.15[${PYTHON_USEDEP}]"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
