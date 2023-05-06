# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the HIDAPI"
HOMEPAGE="
	https://github.com/trezor/cython-hidapi
	https://pypi.org/project/hidapi/
"

LICENSE="|| ( BSD GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/hidapi-$(ver_cut 1-3)"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_prepare() {
	# rename the module to avoid conflict with dev-python/hid
	pushd ${S} || die
		mv hid.pyx hidapi.pyx
		ln -sf hidraw.pyx hidapi.pyx
		sed -i -r '/^src = /s|\[.+|["hidapi.pyx", "chid.pxd"]|' "setup.py" || die
		sed -i -r 's/"hid",/"hidapi",/' "setup.py" || die
		sed -i -r "s/'hid.pyx'/'hidapi.pyx'/" "setup.py" || die
	popd || die

	default
}

python_configure_all() {
	DISTUTILS_ARGS=( --with-system-hidapi )
}
