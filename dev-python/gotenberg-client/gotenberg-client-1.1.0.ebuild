# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A Python client for interfacing with the Gotenberg API"
HOMEPAGE="
	https://github.com/stumpylog/gotenberg-client
	https://pypi.org/project/gotenberg-client/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
		>=dev-python/httpx2-2.0.0[${PYTHON_USEDEP}]
		dev-python/pikepdf[${PYTHON_USEDEP}]
		dev-python/pypdf[${PYTHON_USEDEP}]
	)
"

DOCS=( README.md )

EPYTEST_PLUGINS=( pytest-{asyncio,httpx,mock} flaky )
EPYTEST_IGNORE=(
	# requires niquests
	tests/test_backend_auto.py
)
EPYTEST_DESELECT=(
	# requires magika (llm file type identification)
	tests/test_utils.py::TestGuessMimeTypeMagika::test_detects_content
	tests/test_utils.py::TestGuessMimeTypeMagika::test_accepts_str_path
	tests/test_utils.py::TestGuessMimeTypeMagika::test_model_is_loaded_once
)
distutils_enable_tests pytest

python_test() {
	epytest -m 'not live and not niquests' tests
}

pkg_postinst() {
	optfeature "httpx backend" dev-python/httpx
	optfeature "requests backend" dev-python/requests
	optfeature "MIME-type detection" dev-python/python-magic
}
