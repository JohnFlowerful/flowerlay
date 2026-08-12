# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Extends Django abilities beyond HTTP protocol"
HOMEPAGE="https://github.com/django/channels"
SRC_URI="https://github.com/django/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/asgiref-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/async-timeout[${PYTHON_USEDEP}]
		>=dev-python/daphne-4.0.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,django} )
EPYTEST_IGNORE=(
	tests/sample_project/tests/test_selenium.py
)
distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

python_install() {
	distutils-r1_python_install
	rm -rf "${D}$(python_get_sitedir)"/tests || die
}
