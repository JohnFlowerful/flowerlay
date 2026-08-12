# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )

CRATES=""
declare -A GIT_CRATES=(
	[interprocess]='https://github.com/kotauskas/interprocess;44351c4fe88c72ead4f3b0b762c4cf45beb90841;interprocess-%commit%'
	[tls-listener]='https://github.com/gi0baro/tls-listener;28d8a48209466324343d133414ea9af218faebb3;tls-listener-%commit%'
)
RUST_MIN_VER="1.95"

inherit cargo distutils-r1 pypi

DESCRIPTION="A Rust HTTP server for Python applications"
HOMEPAGE="
	https://github.com/emmett-framework/granian
	https://pypi.org/project/granian/
"
SRC_URI+="
	https://dandelion.ilypetals.net/dist/rust/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="BSD"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT
	Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/click-8.1.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

BDEPEND="
	${RUST_DEPEND}
	>=dev-util/maturin-1.14.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/httpx-0.28[${PYTHON_USEDEP}]
		>=dev-python/sniffio-1.3[${PYTHON_USEDEP}]
		>=dev-python/websockets-16.0[${PYTHON_USEDEP}]
	)
"

DOCS=( README.md )

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

src_unpack() {
	cargo_src_unpack
}

python_test() {
	rm -rf granian || die
	epytest
}
