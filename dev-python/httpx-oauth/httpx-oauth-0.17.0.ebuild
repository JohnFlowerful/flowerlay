# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Async OAuth client using HTTPX"
HOMEPAGE="
	https://github.com/frankie567/httpx-oauth
	https://pypi.org/project/httpx-oauth/
"

LICENSE="MIT-0"
SLOT="0"
KEYWORDS="~amd64"

# httpx is deprecated in gentoo, citing https://github.com/encode/httpx/discussions/3784
RDEPEND="
	>=dev-python/httpx-0.18[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/fastapi[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
	)
"

DOCS=( README.md )

EPYTEST_PLUGINS=( pytest-{asyncio,mock} )
distutils_enable_tests pytest

python_prepare_all() {
	# Disable coverage
	sed -e '/^addopts/d' -i pyproject.toml || die

	distutils-r1_python_prepare_all
}
