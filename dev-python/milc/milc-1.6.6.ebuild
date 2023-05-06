# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Opinionated Batteries-Included Python 3 CLI Framework."
HOMEPAGE="
	https://github.com/clueboard/milc
	https://pypi.org/project/milc/
"
# the pypi archive is missing test files
SRC_URI="
	https://github.com/clueboard/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Clueboard"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/halo[${PYTHON_USEDEP}]
	dev-python/spinners[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/nose2[${PYTHON_USEDEP}]
		dev-python/semver[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	for i in setup.{cfg,py}; do
		sed -i -e 's/author-email/author_email/g' "${S}/${i}" || die
		sed -i -e 's/description-file/description_file/g' "${S}/${i}" || die
		sed -i -e 's/dist-name/dist_name/g' "${S}/${i}" || die
		sed -i -e 's/home-page/home_page/g' "${S}/${i}" || die
	done
	sed -i -e 's/license_file/license_files/g' "${S}/setup.cfg" || die

	default
}

python_test() {
	nose2 -v || die "Tests failed with ${EPYTHON}"
}
