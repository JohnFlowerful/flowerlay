# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="ctypes bindings for hidapi"
HOMEPAGE="
	https://github.com/apmorton/pyhidapi
	https://pypi.org/project/hid/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
# no tests provided by upstream
RESTRICT="test"

RDEPEND="dev-libs/hidapi"

src_prepare() {
	# fix deprecation warnings
	sed -e 's/description-file/description_file/' -i "setup.cfg" || die

	distutils-r1_src_prepare
}
