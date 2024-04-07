# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Beautiful terminal spinners in Python"
HOMEPAGE="
	https://github.com/manrajgrover/halo
	https://pypi.org/project/halo/
"
# the pypi archive is missing test files and upstream doesn't tag releases on github...
HALO_COMMIT="c5f6ef233d5a3ef6c3db9f44aef03a789cb4a6ce"
SRC_URI="
	https://github.com/manrajgrover/${PN}/archive/${HALO_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/log_symbols-0.0.14[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/spinners-0.0.24[${PYTHON_USEDEP}]
	>=dev-python/termcolor-2.2.0[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-python/ipywidgets[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-${HALO_COMMIT}"

src_prepare() {
	# remove colorama
	# https://github.com/manrajgrover/halo/issues/151
	# https://github.com/manrajgrover/halo/pull/152
	sed -r \
		-e '/^from colorama.+/d' \
		-e '/^init\(autoreset=True\)/d' \
		-i "halo/_utils.py" || die

	# newer dev-python/termcolor checks isatty before adding ansi escape codes.
	# this causes colour related tests to fail. force colours to work around this
	sed -e '/^from termcolor import COLORS/i os.environ["FORCE_COLOR"] = "1"' \
		-i "tests/test_"{halo,halo_notebook}".py" || die

	# fix deprecation warnings
	sed -e 's/description-file/description_file/' -i "setup.cfg" || die

	sed -e '/_spinner_thread.*/s|setDaemon(True)|daemon = True|' -i "halo/halo"{,_notebook}".py" || die

	sed -e 's/assertEquals/assertEqual/' \
		-e 's/assertRegexpMatches/assertRegex/' \
		-i "tests/test_"{halo,halo_notebook}".py" || die

	distutils-r1_src_prepare
}
