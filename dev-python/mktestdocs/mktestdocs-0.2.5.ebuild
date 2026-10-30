# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A tool for testing markdown documentation"
HOMEPAGE="
	https://github.com/koaning/mktestdocs
	https://pypi.org/project/mktestdocs/
"
SRC_URI="https://github.com/koaning/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DOCS=( README.md )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
