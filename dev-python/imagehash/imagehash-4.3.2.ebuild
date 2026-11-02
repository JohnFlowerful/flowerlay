# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="A Python perceptual image hashing module"
HOMEPAGE="
	https://github.com/JohannesBuchner/imagehash
	https://pypi.org/project/ImageHash/
"
SRC_URI="https://github.com/JohannesBuchner/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pywavelets[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
