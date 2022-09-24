# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Simple bencode parser (for Python 2, Python 3 and PyPy)"
HOMEPAGE="https://github.com/fuzeman/bencode.py"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> $P.tar.gz"

LICENSE="BitTorrent-1.1"
SLOT="0"
KEYWORDS="amd64"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"