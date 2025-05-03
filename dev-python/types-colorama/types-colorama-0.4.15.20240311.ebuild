# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Typing stubs for colorama"
HOMEPAGE="
	https://github.com/python/typeshed
	https://pypi.org/project/types-colorama/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="test"
