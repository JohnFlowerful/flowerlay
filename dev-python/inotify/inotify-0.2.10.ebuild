# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="An efficient and elegant inotify library for Python"
HOMEPAGE="
	https://github.com/dsoprea/PyInotify
	https://pypi.org/project/inotify/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/dsoprea/PyInotify/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/PyInotify-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

src_prepare() {
	cp --remove-destination $(readlink README.rst) "README.rst" || die

	# inotify sends these events in the opposite order
	# see 'man inotify'
	sed -e "s/\['IN_ISDIR', 'IN_DELETE'\]/\['IN_DELETE', 'IN_ISDIR'\]/" \
		-e "s/\['IN_ISDIR', 'IN_CREATE'\]/\['IN_CREATE', 'IN_ISDIR'\]/" \
		-i "tests/test_inotify.py" || die

	# fix test deprecation warnings
	sed -e 's/assertEquals/assertEqual/' -i "tests/test_inotify.py" || die

	distutils-r1_src_prepare
}
