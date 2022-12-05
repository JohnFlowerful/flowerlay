# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A stripped-down version of the pyrocore tools"
HOMEPAGE="https://kannibalox.github.io/pyrosimple/"
SRC_URI="https://github.com/kannibalox/pyrosimple/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=dev-python/APScheduler-3.9*[${PYTHON_USEDEP}]
	=dev-python/bencode_py-4.0*[${PYTHON_USEDEP}]
	=dev-python/pyinotify-0.9*[${PYTHON_USEDEP}]
	=dev-python/jinja-3.1*[${PYTHON_USEDEP}]
	=dev-python/python-daemon-2.3*[${PYTHON_USEDEP}]
	=dev-python/dynaconf-3.1*[${PYTHON_USEDEP},toml]
	=dev-python/parsimonious-0.10*[${PYTHON_USEDEP}]
	=dev-python/prometheus_client-0.14*[${PYTHON_USEDEP}]
	=dev-python/prompt_toolkit-3.0*[${PYTHON_USEDEP}]
	=dev-python/requests-2.28*[${PYTHON_USEDEP}]
	=dev-python/shtab-1.5*[${PYTHON_USEDEP}]
	=dev-python/inotify-0.2*[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/poetry-core-1.2.0[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

distutils_enable_tests pytest
