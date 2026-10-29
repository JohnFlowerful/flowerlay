# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

# https://github.com/pypdfium2-team/pypdfium2/blob/5.14.0/README.md?plain=1#L68
# no version is provided for ctypesgen. pypdfium2 expects to `git pull` a live
# copy
# the pypi sdist archive has the ctypesgen dep, but it's missing test files
CTYPESGEN_COMMIT="4f5d6e46aa40bb6bc55c5377434eee75ec0ef346"

inherit distutils-r1

DESCRIPTION="Python bindings to PDFium"
HOMEPAGE="https://github.com/pypdfium2-team/pypdfium2"
SRC_URI="
	https://github.com/pypdfium2-team/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/pypdfium2-team/ctypesgen/archive/${CTYPESGEN_COMMIT}.tar.gz
		-> ${PN}-ctypesgen-${CTYPESGEN_COMMIT}.tar.gz
"

LICENSE="Apache-2.0 BSD CC-BY-4.0 LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~app-text/pdfium-8076
"
BDEPEND="
	test? (
		dev-python/pillow[jpeg,jpeg2k,lcms,tiff,truetype,zlib,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/run_cmd2.patch
)

DOCS=( README.md )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

distutils_enable_sphinx docs/source \
	dev-python/myst-parser \
	dev-python/sphinx-issues \
	dev-python/sphinx-rtd-theme \
	dev-python/sphinxcontrib-programoutput

src_prepare() {
	default

	mv "${WORKDIR}/ctypesgen-${CTYPESGEN_COMMIT}" deps/ctypesgen || die

	if use test; then
		rm -rf deps/ctypesgen/tests || die
	fi
}

src_configure() {
	export PDFIUM_PLATFORM="system-search"
	distutils-r1_src_configure
}
