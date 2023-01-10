# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="An efficient and elegant inotify library for Python"
HOMEPAGE="https://github.com/dsoprea/PyInotify"
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/dsoprea/PyInotify/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

# tests will fail because the expected lists are out of order
RESTRICT="test"
distutils_enable_tests nose

S="${WORKDIR}/PyInotify-${PV}"

src_prepare() {
	cp --remove-destination `readlink README.rst` "README.rst" || die

	default
}