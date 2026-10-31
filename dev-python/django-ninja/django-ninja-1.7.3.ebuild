# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Fast Django REST Framework"
HOMEPAGE="
	https://django-ninja.dev/
	https://github.com/vitalik/django-ninja
	https://pypi.org/project/django-ninja/
"
SRC_URI="https://github.com/vitalik/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.0.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/psycopg[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,django} )
distutils_enable_tests pytest
