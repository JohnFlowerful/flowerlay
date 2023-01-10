# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Configuration Management for Python"
HOMEPAGE="https://github.com/dynaconf/dynaconf"
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="ini redis toml vault yaml"
RESTRICT="!test? ( test )"

RDEPEND="
	ini? ( dev-python/configobj[${PYTHON_USEDEP}] )
	redis? ( dev-db/redis )
	toml? ( dev-python/toml[${PYTHON_USEDEP}] )
	vault? ( dev-python/hvac[${PYTHON_USEDEP}] )
	yaml? ( dev-python/ruamel-yaml[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# requires extra setup and deps
		tests/test_django.py
		tests/test_flask.py
		tests/test_redis.py
		tests/test_vault.py
		# also has extra setup and unnecessary deps (docker)
		tests_functional
	)
	epytest
}
