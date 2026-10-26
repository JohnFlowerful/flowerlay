# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

HTML5LIB_TESTS_COMMIT="9fb614afaa42ce8787840f057b32084308e76549"

DESCRIPTION="A fast, fully typed HTML toolkit for Python, powered by a C-accelerated core"
HOMEPAGE="
	https://github.com/tox-dev/turbohtml
	https://pypi.org/project/turbohtml/
"
SRC_URI="
	$(pypi_sdist_url turbohtml)
	test? (
		https://github.com/html5lib/html5lib-tests/archive/${HTML5LIB_TESTS_COMMIT}.tar.gz
			-> html5lib-tests-${HTML5LIB_TESTS_COMMIT}.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# some test deps are not listed under the [test] dep group in pyproject.toml
# assume versions listed in the [bench] group
BDEPEND="
	>=dev-build/meson-1.12.1
	>=dev-python/meson-python-0.22.1
	>=dev-build/ninja-1.13.2
	test? (
		>=dev-python/docutils-0.22.4[${PYTHON_USEDEP}]
		>=dev-python/elementpath-5.1.4[${PYTHON_USEDEP}]
		>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
		>=dev-python/httpx2-2.13.1[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.6[${PYTHON_USEDEP}]
		>=dev-python/markdown-it-py-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-9.1.1[${PYTHON_USEDEP}]
		>=dev-python/tenacity-9.1.4[${PYTHON_USEDEP}]
		>=dev-python/tinycss2-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.16.0[${PYTHON_USEDEP}]

		>=dev-python/beautifulsoup4-4.15.0[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		>=dev-python/feedparser-6.0.14[${PYTHON_USEDEP}]
		>=dev-python/lxml-6.1.3[${PYTHON_USEDEP}]
		>=dev-python/pyquery-2.1.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{cov,mock} )
EPYTEST_XDIST=1
EPYTEST_IGNORE=(
	# irrelevant
	tests/benchmarks
	# irrelevant/pyperf dep
	tests/test_bench_worker.py
	# requires vendored modules. hefty storage reqs, not worth packaging
	tests/conformance
	tests/url/test_idna.py
	# requires the fuzz-only extension build
	tests/test_fuzz_self_test.py
)
EPYTEST_DESELECT=(
	# requires git
	tests/build/test_generate_version.py::test_generate_version_sdist_ignores_enclosing_repository
	tests/build/test_generate_version.py::test_generate_version_uses_own_repository
	tests/build/test_generate_version.py::test_generate_version_uses_own_repository
)
distutils_enable_tests pytest

src_prepare() {
	default

	if use test; then
		# bug 971501
		sed -i '/^            ("chardet", \(False\|True\)),$/d' "${S}/tests/test_detect.py" || die

		mv "${WORKDIR}/html5lib-tests-${HTML5LIB_TESTS_COMMIT}" "${S}/tests/html5lib-tests" || die
	fi
}
