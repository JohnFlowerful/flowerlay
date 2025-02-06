# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

MY_PN=${PN//-/.}
PYPI_NO_NORMALIZE=1
PYPI_PN="${MY_PN}"

inherit distutils-r1 pypi

DESCRIPTION="Simple bencode parser (for Python 2, Python 3 and PyPy)"
HOMEPAGE="
	https://github.com/fuzeman/bencode.py
	https://pypi.org/project/bencode.py/
"

LICENSE="BitTorrent-1.1"
SLOT="0"
KEYWORDS="amd64"

BDEPEND=">=dev-python/pbr-1.9[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	# fix deprecation warnings
	sed -e 's/author-email/author_email/' \
		-e 's/description-file/description_file/' \
		-e 's/home-page/home_page/' \
		-i "setup.cfg" || die

	distutils-r1_src_prepare
}
