# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="A stripped-down version of the pyrocore tools"
HOMEPAGE="
	https://kannibalox.github.io/pyrosimple/
	https://pypi.org/project/pyrosimple/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/kannibalox/pyrosimple/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="queue"

# python-daemon-3.0.1 is recommended but this version isn't in the main gentoo
# repo: https://packages.gentoo.org/packages/dev-python/python-daemon
# there are no tests for `rtcontrol's '--detach' flag due to the inherent nature
# of using the command i.e. it requires rtorrent to be running
# all other tests are passing however
RDEPEND="
	=dev-python/bencode_py-4.0*[${PYTHON_USEDEP}]
	=dev-python/jinja-3.1*[${PYTHON_USEDEP}]
	=dev-python/python-daemon-2.3*[${PYTHON_USEDEP}]
	=dev-python/parsimonious-0.10*[${PYTHON_USEDEP}]
	=dev-python/prometheus_client-0.16*[${PYTHON_USEDEP}]
	=dev-python/prompt-toolkit-3.0*[${PYTHON_USEDEP}]
	=dev-python/requests-2.28*[${PYTHON_USEDEP}]
	=dev-python/shtab-1.5*[${PYTHON_USEDEP}]
	=dev-python/python-box-7.0*[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		=dev-python/tomli-2.0*[${PYTHON_USEDEP}]
	' python3_10)
	=dev-python/tomli-w-1.0*[${PYTHON_USEDEP}]

	queue? (
		=dev-python/APScheduler-3*[${PYTHON_USEDEP}]
		=dev-python/inotify-0.2*[${PYTHON_USEDEP}]
	)
"
BDEPEND="test? ( ${RDEPEND} )"

distutils_enable_tests pytest
