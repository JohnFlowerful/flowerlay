# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Whoosh query-language parser emitting programmatic tantivy queries"
HOMEPAGE="
	https://github.com/stumpylog/whoosh-compat
	https://pypi.org/project/whoosh-compat/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"

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
