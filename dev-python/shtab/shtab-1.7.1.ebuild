# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Automagic shell tab completion for Python CLI applications"
HOMEPAGE="
	https://github.com/iterative/shtab
	https://pypi.org/project/shtab/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's/--cov=shtab --cov-report=term-missing --cov-report=xml//' -i pyproject.toml || die

	distutils-r1_src_prepare
}
