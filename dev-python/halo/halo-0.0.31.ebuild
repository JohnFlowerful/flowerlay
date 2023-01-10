# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Beautiful terminal spinners in Python"
HOMEPAGE="https://github.com/manrajgrover/halo"
# the pypi archive is missing test files and upstream doesn't tag releases on github...
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
HALO_COMMIT="c5f6ef233d5a3ef6c3db9f44aef03a789cb4a6ce"
SRC_URI="https://github.com/manrajgrover/${PN}/archive/${HALO_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
	=dev-python/log_symbols-0.0.14[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/spinners-0.0.24[${PYTHON_USEDEP}]
	>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/ipywidgets[${PYTHON_USEDEP}] )"

distutils_enable_tests nose

S="${WORKDIR}/${PN}-${HALO_COMMIT}"

src_prepare() {
	sed -i -e 's/description-file/description_file/g' "${S}/setup.cfg" || die
	default
}
