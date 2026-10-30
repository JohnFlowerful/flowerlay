# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Simple bencode parser (for Python 2, Python 3 and PyPy)"
HOMEPAGE="
	https://github.com/fuzeman/bencode.py
	https://pypi.org/project/bencode.py/
"
SRC_URI="https://github.com/fuzeman/bencode.py/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN//-/.}-${PV}"

LICENSE="BitTorrent-1.1"
SLOT="0"
KEYWORDS="amd64"

PATCHES=( "${FILESDIR}/build-system-${PV}.patch" )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	default

	# fixture nests 1500 deep while the trigger expects max_depth=10000, thus
	# never triggering the error
	sed -i 's/max_depth=10000/max_depth=1000/' \
		tests/bencodepy/file_tests.py \
		tests/bencodepy/bencode_tests.py
}
