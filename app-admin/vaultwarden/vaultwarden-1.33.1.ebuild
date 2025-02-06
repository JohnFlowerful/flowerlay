# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[yubico]='https://github.com/BlackDex/yubico-rs;00df14811f58155c0f02e3ab10f1570ed3e115c6;yubico-rs-%commit%'
)

RUST_MIN_VER="1.84.1"

inherit cargo check-reqs

DESCRIPTION="Unofficial Bitwarden compatible server written in Rust"
HOMEPAGE="https://github.com/dani-garcia/vaultwarden"

SRC_URI="
	https://github.com/dani-garcia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/rust/${PN}-${PV}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="AGPL-3"
# Dependent crate licenses
LICENSE+=" 0BSD Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+lto mysql postgres +sqlite +system-sqlite thinlto +web-vault"
REQUIRED_USE="|| ( mysql postgres sqlite )"
RESTRICT="mirror"

DEPEND="
	dev-libs/openssl:0=
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )
	web-vault? ( >=app-admin/vaultwarden-web-vault-2025.1.1 )
"
RDEPEND="
	${DEPEND}
	acct-group/vaultwarden
	acct-user/vaultwarden
"

pre_build_checks() {
	local CHECKREQS_DISK_BUILD=2G
	local CHECKREQS_MEMORY=1G
	if use lto; then
		CHECKREQS_MEMORY=3G
	fi

	check-reqs_${EBUILD_PHASE_FUNC}
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks
	rust_pkg_setup
}

src_prepare() {
	if use system-sqlite; then
		sed -e '/^libsqlite3-sys =.*/s|features = \["bundled"\], ||' \
			-i "Cargo.toml" || die
	fi

	sed -r "s/^# (WEB_VAULT_ENABLED)=.*/\1=$(usex web-vault true false)/" \
		-i .env.template || die

	# source: cargo.eclass
	local crate commit crate_uri crate_dir host
	for crate in "${!GIT_CRATES[@]}"; do
		IFS=';' read -r crate_uri commit crate_dir host <<< "${GIT_CRATES[${crate}]}"
		: "${crate_dir:=${crate}-%commit%}"
		sed -r "s|^${crate} = \{ git.*|${crate} = { path = \"${WORKDIR}/${crate_dir//%commit%/${commit}}\" }|" \
			-i  "Cargo.toml" || die
	done
	cargo_update_crates

	default
}

src_configure() {
	myfeatures=(
		$(usev mysql)
		$(usex postgres postgresql '')
		$(usev sqlite)
	)

	cargo_src_configure
}

src_compile() {
	export VW_VERSION="${PV}"

	if use thinlto; then
		# or --profile release-low
		export CARGO_PROFILE_RELEASE_LTO=thin
		export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
	fi
	if ! use lto && ! use thinlto; then
		# this was the behaviour of vaultwarden <= 1.30.1
		export CARGO_PROFILE_RELEASE_LTO=off
		export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
	fi

	cargo_src_compile
}

src_install() {
	cargo_src_install

	einstalldocs

	# Install init.d and conf.d scripts
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	# Install /etc/vaultwarden.env
	insinto /etc
	newins .env.template "${PN}.env"
	fowners root:vaultwarden "/etc/${PN}.env"
	fperms 640 "/etc/${PN}.env"

	# Install launch wrapper
	exeinto "/var/lib/${PN}"
	doexe "${FILESDIR}/${PN}"

	# Keep data dir
	keepdir "/var/lib/${PN}/data"
	fowners vaultwarden:vaultwarden "/var/lib/${PN}/data"
	fperms 700 "/var/lib/${PN}/data"
}
