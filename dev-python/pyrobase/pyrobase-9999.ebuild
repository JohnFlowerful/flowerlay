# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils git-r3

MY_P="${PN}-${PV}"

DESCRIPTION="General purpose proxy and wrapper types"
HOMEPAGE="https://github.com/pyroscope/pyrobase"
EGIT_REPO_URI="https://github.com/pyroscope/pyrobase.git"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=">=dev-python/epydoc-3.0.1
	>=dev-python/tempita-0.5.2"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

src_prepare() {
	epatch "${FILESDIR}"/docs.patch
}
