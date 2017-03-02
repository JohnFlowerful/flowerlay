# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

MY_P="${PN}-${PV}"

DESCRIPTION="A collection of tools for the BitTorrent protocol and especially the rTorrent client"
HOMEPAGE="http://pyrocore.readthedocs.org/en/latest/"
EGIT_REPO_URI="https://github.com/pyroscope/pyrocore.git"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="x86 amd64"
IUSE=""

PATCHES=( "${FILESDIR}"/data.patch "${FILESDIR}"/update.patch )

COMMON_DEPEND=">=dev-python/APScheduler-2.0.2
	>=dev-python/pyinotify-0.9.3
	>=dev-python/waitress-0.8.2
	>=dev-python/webob-1.2.3
	>=dev-python/psutil-0.6.1
	>=dev-python/requests-2.3.0
	>=dev-python/tempita-0.5.1
	>=dev-python/proxytypes-0.5.1
	dev-python/pyrobase
	dev-python/auvyon"
RDEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

