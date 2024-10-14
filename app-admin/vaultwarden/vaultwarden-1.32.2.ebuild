# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	allocator-api2@0.2.18
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	argon2@0.5.3
	async-channel@1.9.0
	async-channel@2.3.1
	async-compression@0.4.14
	async-executor@1.13.1
	async-global-executor@2.4.1
	async-io@2.3.4
	async-lock@3.4.0
	async-process@2.3.0
	async-signal@0.2.10
	async-std@1.13.0
	async-stream-impl@0.3.6
	async-stream@0.3.6
	async-task@4.7.1
	async-trait@0.1.83
	atomic-waker@1.1.2
	atomic@0.5.3
	atomic@0.6.0
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.13.1
	base64@0.21.7
	base64@0.22.1
	base64ct@1.6.0
	bigdecimal@0.4.5
	binascii@0.1.4
	bitflags@1.3.2
	bitflags@2.6.0
	blake2@0.10.6
	block-buffer@0.10.4
	blocking@1.6.1
	brotli-decompressor@4.0.1
	brotli@7.0.0
	bumpalo@3.16.0
	bytemuck@1.18.0
	byteorder@1.5.0
	bytes@1.7.2
	cached@0.53.1
	cached_proc_macro@0.23.0
	cached_proc_macro_types@0.1.1
	cc@1.1.29
	cfg-if@1.0.0
	chrono-tz-build@0.4.0
	chrono-tz@0.10.0
	chrono@0.4.38
	chumsky@0.9.3
	concurrent-queue@2.5.0
	cookie@0.18.1
	cookie_store@0.21.0
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	cpufeatures@0.2.14
	crc32fast@1.4.2
	cron@0.12.1
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	dashmap@5.5.3
	dashmap@6.1.0
	data-encoding@2.6.0
	data-url@0.3.1
	deranged@0.3.11
	devise@0.4.2
	devise_codegen@0.4.2
	devise_core@0.4.2
	diesel@2.2.4
	diesel_derives@2.2.3
	diesel_logger@0.3.0
	diesel_migrations@2.2.0
	diesel_table_macro_syntax@0.2.0
	digest@0.10.7
	displaydoc@0.2.5
	dotenvy@0.15.7
	dsl_auto_type@0.1.2
	either@1.13.0
	email-encoding@0.3.0
	email_address@0.2.9
	encoding_rs@0.8.34
	enum-as-inner@0.6.1
	equivalent@1.0.1
	errno@0.3.9
	error-chain@0.12.4
	event-listener-strategy@0.5.2
	event-listener@2.5.3
	event-listener@5.3.1
	fastrand@2.1.1
	fern@0.6.2
	figment@0.10.19
	flate2@1.0.34
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-lite@2.3.0
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-timer@3.0.3
	futures-util@0.3.31
	futures@0.3.31
	generator@0.7.5
	generic-array@0.14.7
	getrandom@0.2.15
	gimli@0.31.1
	glob@0.3.1
	gloo-timers@0.3.0
	governor@0.6.3
	h2@0.3.26
	h2@0.4.6
	half@1.8.3
	handlebars@6.1.0
	hashbrown@0.14.5
	hashbrown@0.15.0
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	hickory-proto@0.24.1
	hickory-resolver@0.24.1
	hmac@0.12.1
	home@0.5.9
	hostname@0.3.1
	hostname@0.4.0
	html5gum@0.5.7
	http-body-util@0.1.2
	http-body@0.4.6
	http-body@1.0.1
	http@0.2.12
	http@1.1.0
	httparse@1.9.5
	httpdate@1.0.3
	hyper-rustls@0.27.3
	hyper-tls@0.5.0
	hyper-tls@0.6.0
	hyper-util@0.1.9
	hyper@0.14.30
	hyper@1.4.1
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	ident_case@1.0.1
	idna@0.3.0
	idna@0.4.0
	idna@0.5.0
	idna@1.0.2
	indexmap@2.6.0
	inlinable_string@0.1.15
	ipconfig@0.3.2
	ipnet@2.10.1
	is-terminal@0.4.13
	itoa@1.0.11
	jetscii@0.5.3
	job_scheduler_ng@2.0.5
	js-sys@0.3.72
	jsonwebtoken@9.3.0
	kv-log-macro@1.0.7
	lazy_static@1.5.0
	lettre@0.11.9
	libc@0.2.159
	libm@0.2.8
	libmimalloc-sys@0.1.39
	libsqlite3-sys@0.30.1
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.14
	litemap@0.7.3
	lock_api@0.4.12
	log@0.4.22
	loom@0.5.6
	lru-cache@0.1.2
	match_cfg@0.1.0
	matchers@0.1.0
	memchr@2.7.4
	migrations_internals@2.2.0
	migrations_macros@2.2.0
	mimalloc@0.1.43
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.8.0
	mio@1.0.2
	multer@3.1.0
	mysqlclient-sys@0.4.1
	native-tls@0.2.12
	no-std-compat@0.4.1
	nom@7.1.3
	nonzero_ext@0.3.0
	nu-ansi-term@0.46.0
	num-bigint@0.4.6
	num-conv@0.1.0
	num-derive@0.4.2
	num-integer@0.1.46
	num-traits@0.2.19
	num_cpus@1.16.0
	num_threads@0.1.7
	object@0.36.5
	once_cell@1.20.2
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-src@300.3.2+3.3.2
	openssl-sys@0.9.103
	openssl@0.10.66
	overload@0.1.1
	parking@2.2.1
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	parse-zoneinfo@0.3.1
	password-hash@0.5.0
	paste@1.0.15
	pear@0.2.9
	pear_codegen@0.2.9
	pem@3.0.4
	percent-encoding@2.3.1
	pest@2.7.13
	pest_derive@2.7.13
	pest_generator@2.7.13
	pest_meta@2.7.13
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.11.2
	phf_shared@0.11.2
	pico-args@0.5.0
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	piper@0.2.4
	pkg-config@0.3.31
	polling@3.7.3
	portable-atomic@1.9.0
	powerfmt@0.2.0
	ppv-lite86@0.2.20
	pq-sys@0.6.3
	proc-macro2-diagnostics@0.10.1
	proc-macro2@1.0.87
	psl-types@2.0.11
	psm@0.1.23
	publicsuffix@2.2.3
	quanta@0.12.3
	quick-error@1.2.3
	quote@1.0.37
	quoted_printable@0.5.1
	r2d2@0.8.10
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	raw-cpuid@11.2.0
	redox_syscall@0.5.7
	ref-cast-impl@1.0.23
	ref-cast@1.0.23
	regex-automata@0.1.10
	regex-automata@0.4.8
	regex-syntax@0.6.29
	regex-syntax@0.8.5
	regex@1.11.0
	reopen@1.0.3
	reqwest@0.11.27
	reqwest@0.12.8
	resolv-conf@0.7.0
	ring@0.17.8
	rmp@0.8.14
	rmpv@1.3.0
	rocket@0.5.1
	rocket_codegen@0.5.1
	rocket_http@0.5.1
	rocket_ws@0.1.1
	rpassword@7.3.1
	rtoolbox@0.0.2
	rustc-demangle@0.1.24
	rustix@0.38.37
	rustls-pemfile@1.0.4
	rustls-pemfile@2.2.0
	rustls-pki-types@1.9.0
	rustls-webpki@0.101.7
	rustls-webpki@0.102.8
	rustls@0.21.12
	rustls@0.23.14
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	schannel@0.1.26
	scheduled-thread-pool@0.2.7
	scoped-tls@1.0.1
	scopeguard@1.2.0
	sct@0.7.1
	security-framework-sys@2.12.0
	security-framework@2.11.1
	semver@1.0.23
	serde@1.0.210
	serde_cbor@0.11.2
	serde_derive@1.0.210
	serde_json@1.0.128
	serde_spanned@0.6.8
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.8
	sharded-slab@0.1.7
	shlex@1.3.0
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	simple_asn1@0.6.2
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	spin@0.9.8
	spinning_top@0.3.0
	stable-pattern@0.1.0
	stable_deref_trait@1.2.0
	stacker@0.1.17
	state@0.6.0
	strsim@0.11.1
	subtle@2.6.1
	syn@2.0.79
	sync_wrapper@0.1.2
	sync_wrapper@1.0.1
	synstructure@0.13.1
	syslog@6.1.1
	system-configuration-sys@0.5.0
	system-configuration-sys@0.6.0
	system-configuration@0.5.1
	system-configuration@0.6.1
	tempfile@3.13.0
	thiserror-impl@1.0.64
	thiserror@1.0.64
	thread_local@1.1.8
	threadpool@1.8.1
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinystr@0.7.6
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	tokio-macros@2.4.0
	tokio-native-tls@0.3.1
	tokio-rustls@0.24.1
	tokio-rustls@0.26.0
	tokio-socks@0.5.2
	tokio-stream@0.1.16
	tokio-tungstenite@0.21.0
	tokio-util@0.7.12
	tokio@1.40.0
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.22
	totp-lite@2.0.1
	tower-service@0.3.3
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing@0.1.40
	try-lock@0.2.5
	tungstenite@0.21.0
	typenum@1.17.0
	ubyte@0.10.4
	ucd-trie@0.1.7
	uncased@0.9.10
	unicode-bidi@0.3.17
	unicode-ident@1.0.13
	unicode-normalization@0.1.24
	unicode-xid@0.2.6
	untrusted@0.9.0
	url@2.5.2
	utf-8@0.7.6
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	uuid@1.10.0
	valuable@0.1.0
	value-bag@1.9.0
	vcpkg@0.2.15
	version_check@0.9.5
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-futures@0.4.45
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	wasm-streams@0.4.1
	web-sys@0.3.72
	web-time@1.1.0
	webauthn-rs@0.3.2
	which@6.0.3
	widestring@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-registry@0.2.0
	windows-result@0.2.0
	windows-strings@0.1.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.48.0
	windows@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.20
	winreg@0.50.0
	winsafe@0.0.19
	write16@1.0.0
	writeable@0.5.5
	yansi@1.0.1
	yoke-derive@0.7.4
	yoke@0.7.4
	yubico@0.11.0
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zerofrom-derive@0.1.4
	zerofrom@0.1.4
	zeroize@1.8.1
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

inherit cargo check-reqs

DESCRIPTION="Unofficial Bitwarden compatible server written in Rust"
HOMEPAGE="https://github.com/dani-garcia/vaultwarden"

SRC_URI="
	https://github.com/dani-garcia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="AGPL-3"
# Dependent crate licenses
LICENSE+=" 0BSD Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
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
	web-vault? ( >=app-admin/vaultwarden-web-vault-2024.6.2c )
"
RDEPEND="
	${DEPEND}
	acct-group/vaultwarden
	acct-user/vaultwarden
"
BDEPEND=">=virtual/rust-1.79.0"

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
}

src_prepare() {
	if use system-sqlite; then
		sed -e '/^libsqlite3-sys =.*/s|features = \["bundled"\], ||' \
			-i "Cargo.toml" || die
	fi

	sed -r "s/^# (WEB_VAULT_ENABLED)=.*/\1=$(usex web-vault true false)/" \
		-i .env.template || die

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
	elif ! use lto && ! use thinlto; then
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
