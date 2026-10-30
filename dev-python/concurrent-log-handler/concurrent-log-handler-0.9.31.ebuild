# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{13..14} )

inherit distutils-r1

DESCRIPTION="Robust concurrent logging handlers for Python's standard logging"
HOMEPAGE="
	https://github.com/Preston-Landers/concurrent-log-handler
	https://pypi.org/project/concurrent-log-handler/
"
SRC_URI="https://github.com/Preston-Landers/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/portalocker-2.6.0[${PYTHON_USEDEP}]"

EPYTEST_PLUGINS=( pytest-{mock,sugar} )
distutils_enable_tests pytest
