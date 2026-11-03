# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
declare -A GIT_CRATES=(
	[dashmap]='https://github.com/pnpm/dashmap;4401b5c0b2626266dd5d5a9202677bca8b53e57a;dashmap-%commit%'
	[libsql-ffi]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/libsql-ffi'
	[libsql-hrana]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/libsql-hrana'
	[libsql-rusqlite]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/vendored/rusqlite'
	[libsql-sqlite3-parser]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/vendored/sqlite3-parser'
	[libsql-sys]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/libsql-sys'
	[libsql]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/libsql'
	[libsql_replication]='https://github.com/pnpm/libsql;e2c44e616a1f8e1ec7ceeb61138a3c2c391c35a9;libsql-%commit%/libsql-replication'
	[node-semver]='https://github.com/pnpm/node-semver-rs;3d74d6b7f4de1de2006cf2f7663aac09de65b1f6;node-semver-rs-%commit%'
)
RUST_MIN_VER="1.97.0"

inherit cargo wrapper

DESCRIPTION="Fast, disk space efficient package manager"
HOMEPAGE="https://pnpm.io"
SRC_URI="
	https://github.com/pnpm/pnpm/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://crunchday.io/dist/rust/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0
	CDLA-Permissive-2.0 ISC MIT MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="net-libs/nodejs"

src_prepare() {
	default

	local crate commit crate_uri crate_dir host
	for crate in "${!GIT_CRATES[@]}"; do
		IFS=';' read -r crate_uri commit crate_dir host <<< "${GIT_CRATES[${crate}]}"
		: "${crate_dir:=${crate}-%commit%}"
		sed -r "s|^${crate} = \{ git.*|${crate} = { path = \"${WORKDIR}/${crate_dir//%commit%/${commit}}\" }|" \
			-i  "Cargo.toml" || die
	done
	cargo_update_crates
}

src_compile() {
	cargo_src_compile -p pnpm-cli
}

src_install() {
	# The workspace root is a virtual manifest and cargo install takes no -p.
	cargo_src_install --path pnpm/crates/cli

	# The executable resolves its own path, so an alias cannot be a symlink.
	make_wrapper pn pnpm
	make_wrapper pnpx "pnpm dlx"
	make_wrapper pnx "pnpm dlx"
}
