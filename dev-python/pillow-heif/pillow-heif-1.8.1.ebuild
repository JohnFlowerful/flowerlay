# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Python interface for libheif library"
HOMEPAGE="
	https://github.com/bigcat88/pillow_heif
	https://pypi.org/project/pillow-heif/
"
SRC_URI="https://github.com/bigcat88/pillow_heif/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/pillow_heif-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pillow-11.1.0[${PYTHON_USEDEP}]
	>=media-libs/libheif-1.23.6:=
"
BDEPEND="
	test? (
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[jpeg,lcms,webp,zlib,${PYTHON_USEDEP}]
		>=media-libs/libheif-1.23.6:=[x265]
		media-libs/opencv[png,python,${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.21.0-respect-cflags.patch" )

EPYTEST_PLUGINS=()
# https://github.com/bigcat88/pillow_heif/issues/518
EPYTEST_DESELECT=(
	tests/numpy_test.py::test_numpy_disable_stride_removal
	tests/read_test.py::test_heif_corrupted_open
	tests/thumbnails_test.py::test_pillow_draft_broken_thumbnail
)
distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/sphinx-rtd-theme
