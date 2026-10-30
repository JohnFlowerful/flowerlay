# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Whoosh query-language parser emitting programmatic tantivy queries"
HOMEPAGE="
	https://github.com/stumpylog/whoosh-compat
	https://pypi.org/project/whoosh-compat/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/python-dateutil-2.8
"
BDEPEND="
	test? (
		>=dev-python/tantivy-0.26.0
		dev-python/types-python-dateutil
		dev-python/tzdata
		dev-python/whoosh
	)
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

python_test() {
	if has_version ">=dev-python/tantivy-0.27.0"; then
		EPYTEST_DESELECT+=(
			# these tests are expected to fail with >=dev-python/tantivy-0.27.0. see [1]
			# [1]: https://github.com/stumpylog/whoosh-compat/tree/main#the-json-subpath-carve-out
			tests/emitter/test_emit_json.py::test_json_subpath_parse_query_fallback_honors_multitoken_and_or
			tests/emitter/test_emit_json.py::test_json_subpath_phrase_fallback_slop_is_silently_ignored
			tests/emitter/test_emit_json.py::test_json_subpath_phrase_fallback_ignores_multitoken
			tests/emitter/test_emit_json.py::test_json_subpath_phrase_fallback_ignores_multitoken
			tests/emitter/test_emit_json.py::test_json_subpath_phrase_fallback_ignores_multitoken
			tests/emitter/test_emit_json.py::test_json_subpath_phrase_fallback_ignores_multitoken

			# probably also related to the above
			tests/emitter/test_emit_json.py::test_json_subpath_term
			tests/emitter/test_emit_json.py::test_json_subpath_multitoken_and
			tests/emitter/test_kind_matrix.py::test_json_subpath_phrase_slop_and_multitoken
		)
	fi

	epytest
}
