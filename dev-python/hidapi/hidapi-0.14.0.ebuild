# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A Cython interface to HIDAPI library."
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

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.0-cython3.patch
)

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# rename the module to avoid conflict with dev-python/hid
	mv hid.pyx hidapi.pyx || die
	ln -sf hidapi.pyx hidraw.pyx || die
	sed -r \
		-e '/^src = /s|\[.+|["hidapi.pyx"]|' \
		-e 's/"hid",/"hidapi",/' \
		-e "s/'hid.pyx'/'hidapi.pyx'/" \
		-i "setup.py" || die
}

python_configure_all() {
	DISTUTILS_ARGS=( --with-system-hidapi )
}

python_test() {
	epytest tests.py
}
