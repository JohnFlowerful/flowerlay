# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

MY_PN=${PN//-/_}

inherit distutils-r1

DESCRIPTION="Dictionary wrapper for quick access to deeply nested keys."
HOMEPAGE="
	https://github.com/pawelzny/dotty_dict
	https://pypi.org/project/dotty-dict/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/pawelzny/${MY_PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest
