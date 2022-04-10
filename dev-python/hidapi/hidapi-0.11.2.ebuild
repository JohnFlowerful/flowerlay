# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the HIDAPI "
HOMEPAGE="https://github.com/trezor/cython-hidapi"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/hidapi-0.11.0"
RDEPEND="
	${DEPEND}"

distutils_enable_tests pytest

src_prepare() {
	# rename the module to avoid conflict with dev-python/hid
	pushd ${S}
	mv hid.pyx hidapi.pyx
	ln -sf hidraw.pyx hidapi.pyx
	sed -i -r '/^src = /s|\[.+|["hidapi.pyx", "chid.pxd"]|' "setup.py" || die
	sed -i -r 's/"hid",/"hidapi",/' "setup.py" || die
	popd
	default
}

python_configure_all() {
	DISTUTILS_ARGS=( --with-system-hidapi )
}
