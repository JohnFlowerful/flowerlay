# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )

MY_PN="${PN}-py"

CRATES=""
RUST_MIN_VER="1.88.0"

inherit cargo distutils-r1

DESCRIPTION="Official Python bindings for the Tantivy search engine"
HOMEPAGE="
	https://github.com/quickwit-oss/tantivy-py
	https://pypi.org/project/tantivy/
"
SRC_URI="
	https://github.com/quickwit-oss/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://dandelion.ilypetals.net/dist/rust/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	${RUST_DEPEND}
	>=dev-util/maturin-1.9.3[${PYTHON_USEDEP}]
	<dev-util/maturin-2.0.0[${PYTHON_USEDEP}]

"

EPYTEST_PLUGINS=( mktestdocs )
distutils_enable_tests pytest

src_unpack() {
	cargo_src_unpack
}

python_test() {
	rm -rf tantivy || die
	epytest
}
