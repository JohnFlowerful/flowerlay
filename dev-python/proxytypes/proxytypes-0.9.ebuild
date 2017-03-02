# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="ProxyTypes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="General purpose proxy and wrapper types"
HOMEPAGE="http://cheeseshop.python.org/pypi/ProxyTypes"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}/${MY_P}"
# Source for tests incomplete
