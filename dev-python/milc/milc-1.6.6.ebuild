# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Opinionated Batteries-Included Python 3 CLI Framework."
HOMEPAGE="https://github.com/clueboard/milc"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Clueboard"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	dev-python/appdirs
	dev-python/argcomplete
	dev-python/colorama
	dev-python/halo
	dev-python/spinners"

distutils_enable_tests nose

src_prepare() {
	for i in setup.{cfg,py}; do
		sed -i -e 's/author-email/author_email/g' "${S}/${i}" || die
		sed -i -e 's/description-file/description_file/g' "${S}/${i}" || die
		sed -i -e 's/dist-name/dist_name/g' "${S}/${i}" || die
		sed -i -e 's/home-page/home_page/g' "${S}/${i}" || die
	done
	default
}