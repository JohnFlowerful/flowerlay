# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_9 )

inherit distutils-r1 git-r3

MY_P="${PN}-${PV}"

DESCRIPTION="A collection of tools for the BitTorrent protocol and especially the rTorrent client"
HOMEPAGE="http://pyrocore.readthedocs.org/en/latest/"
EGIT_REPO_URI="https://github.com/pyroscope/pyrocore.git"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="x86 amd64"
IUSE=""

COMMON_DEPEND=">=dev-python/APScheduler-3.6.3
	>=dev-python/pyinotify-0.9.6
	>=dev-python/waitress-0.9.0
	>=dev-python/webob-1.6.1
	>=dev-python/psutil-4.3.0
	>=dev-python/requests-2.10.0
	>=dev-python/tempita-0.5.1
	>=dev-python/prompt_toolkit-1.0.14
	dev-python/pyrobase"
RDEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	eapply "${FILESDIR}/py3.patch"
	sed -i -r "s|EGG-INFO|share/doc/${MY_P}|" "${S}/pavement.py" || die

	distutils-r1_python_prepare_all
}

python_compile() {
	# upstreams setup.py complains about -j so do it manually here
	esetup.py pavement.build
}
