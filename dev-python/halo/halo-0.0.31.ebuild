# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Beautiful terminal spinners in Python"
HOMEPAGE="https://github.com/manrajgrover/halo"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	>=dev-python/colorama-0.3.9
	=dev-python/log_symbols-0.0.14
	>=dev-python/six-1.12.0
	>=dev-python/spinners-0.0.24
	>=dev-python/termcolor-1.1.0"

RESTRICT="test"

src_prepare() {
	sed -i -e 's/description-file/description_file/g' "${S}/setup.cfg" || die
	default
}
