# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

MY_P="${PN}-${PV}"

DESCRIPTION="General purpose proxy and wrapper types"
HOMEPAGE="https://github.com/pyroscope/pyrobase"
EGIT_REPO_URI="https://github.com/pyroscope/pyrobase.git"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND=">=dev-python/tempita-0.5.2"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed -i -r "s|EGG-INFO|share/doc/${MY_P}|" "${S}/pavement.py" || die

	distutils-r1_python_prepare_all
}
