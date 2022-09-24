# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="A stripped-down version of the pyrocore tools"
HOMEPAGE="https://kannibalox.github.io/pyrosimple/"
SRC_URI="https://github.com/kannibalox/pyrosimple/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=dev-python/APScheduler-3*
	=dev-python/bencode_py-4*
	=dev-python/pyinotify-0.9*
	=dev-python/jinja-3*
	=dev-python/python-daemon-2*
	=dev-python/dynaconf-3*
	=dev-python/parsimonious-0*
	=dev-python/prometheus_client-0*
	=dev-python/prompt_toolkit-3*
	=dev-python/requests-2*
"
BDEPEND="
	>=dev-python/poetry-core-1.2.0
	test? ( ${RDEPEND} )
"

distutils_enable_tests pytest