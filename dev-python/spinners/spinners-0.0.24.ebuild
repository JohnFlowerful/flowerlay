# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Spinners for terminals"
HOMEPAGE="https://github.com/manrajgrover/py-spinners"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's/description-file/description_file/g' "${S}/setup.cfg" || die
	default
}