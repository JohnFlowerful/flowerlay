# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	aho-corasick-0.7.20
	alloc-no-stdlib-2.0.4
	alloc-stdlib-0.2.2
	android_system_properties-0.1.5
	argon2-0.5.0
	async-channel-1.8.0
	async-compression-0.3.15
	async-executor-1.5.0
	async-global-executor-2.3.1
	async-io-1.13.0
	async-lock-2.7.0
	async-process-1.6.0
	async-std-1.12.0
	async-stream-0.3.4
	async-stream-impl-0.3.4
	async-task-4.4.0
	async-trait-0.1.68
	async_once-0.2.6
	atomic-0.5.1
	atomic-waker-1.1.0
	autocfg-1.1.0
	base64-0.13.1
	base64-0.21.0
	base64ct-1.6.0
	binascii-0.1.4
	bitflags-1.3.2
	bitflags-2.0.2
	blake2-0.10.6
	block-buffer-0.10.4
	blocking-1.3.0
	brotli-3.3.4
	brotli-decompressor-2.3.4
	bumpalo-3.12.0
	byteorder-1.4.3
	bytes-1.4.0
	cached-0.42.0
	cached_proc_macro-0.16.0
	cached_proc_macro_types-0.1.0
	cc-1.0.79
	cfg-if-1.0.0
	chrono-0.4.24
	chrono-tz-0.8.1
	chrono-tz-build-0.1.0
	codespan-reporting-0.11.1
	concurrent-queue-2.1.0
	cookie-0.16.2
	cookie-0.17.0
	cookie_store-0.16.1
	cookie_store-0.19.0
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.6
	crc32fast-1.3.2
	cron-0.12.0
	crossbeam-utils-0.8.15
	crypto-common-0.1.6
	ctor-0.1.26
	cxx-1.0.94
	cxx-build-1.0.94
	cxxbridge-flags-1.0.94
	cxxbridge-macro-1.0.94
	darling-0.14.4
	darling_core-0.14.4
	darling_macro-0.14.4
	dashmap-5.4.0
	data-encoding-2.3.3
	data-url-0.2.0
	devise-0.4.1
	devise_codegen-0.4.1
	devise_core-0.4.1
	diesel-2.0.3
	diesel_derives-2.0.2
	diesel_logger-0.2.0
	diesel_migrations-2.0.0
	digest-0.10.6
	dotenvy-0.15.7
	either-1.8.1
	email-encoding-0.2.0
	email_address-0.2.4
	encoding_rs-0.8.32
	enum-as-inner-0.5.1
	errno-0.3.0
	errno-dragonfly-0.1.2
	error-chain-0.12.4
	event-listener-2.5.3
	fastrand-1.9.0
	fern-0.6.2
	figment-0.10.8
	flate2-1.0.25
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.1.0
	futures-0.3.28
	futures-channel-0.3.28
	futures-core-0.3.28
	futures-executor-0.3.28
	futures-io-0.3.28
	futures-lite-1.12.0
	futures-macro-0.3.28
	futures-sink-0.3.28
	futures-task-0.3.28
	futures-timer-3.0.2
	futures-util-0.3.28
	generator-0.7.3
	generic-array-0.14.7
	getrandom-0.2.8
	glob-0.3.1
	gloo-timers-0.2.6
	governor-0.5.1
	h2-0.3.16
	half-1.8.2
	handlebars-4.3.6
	hashbrown-0.12.3
	hashbrown-0.13.2
	heck-0.4.1
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	hmac-0.12.1
	hostname-0.3.1
	html5gum-0.5.2
	http-0.2.9
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.2
	hyper-0.14.25
	hyper-tls-0.5.0
	iana-time-zone-0.1.54
	iana-time-zone-haiku-0.1.1
	ident_case-1.0.1
	idna-0.2.3
	idna-0.3.0
	indexmap-1.9.3
	inlinable_string-0.1.15
	instant-0.1.12
	io-lifetimes-1.0.9
	ipconfig-0.3.1
	ipnet-2.7.2
	is-terminal-0.4.6
	itoa-1.0.6
	jetscii-0.5.3
	job_scheduler_ng-2.0.4
	js-sys-0.3.61
	jsonwebtoken-8.3.0
	kv-log-macro-1.0.7
	lazy_static-1.4.0
	lettre-0.10.4
	libc-0.2.140
	libmimalloc-sys-0.1.30
	libsqlite3-sys-0.25.2
	link-cplusplus-1.0.8
	linked-hash-map-0.5.6
	linux-raw-sys-0.3.1
	lock_api-0.4.9
	log-0.4.17
	loom-0.5.6
	lru-cache-0.1.2
	mach-0.3.2
	match_cfg-0.1.0
	matchers-0.1.0
	matches-0.1.10
	memchr-2.5.0
	migrations_internals-2.0.0
	migrations_macros-2.0.0
	mimalloc-0.1.34
	mime-0.3.17
	minimal-lexical-0.2.1
	miniz_oxide-0.6.2
	mio-0.8.6
	multer-2.1.0
	mysqlclient-sys-0.2.5
	native-tls-0.2.11
	no-std-compat-0.4.1
	nom-7.1.3
	nonzero_ext-0.3.0
	nu-ansi-term-0.46.0
	num-bigint-0.4.3
	num-derive-0.3.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.15.0
	num_threads-0.1.6
	once_cell-1.17.1
	openssl-0.10.49
	openssl-macros-0.1.1
	openssl-probe-0.1.5
	openssl-src-111.25.2+1.1.1t
	openssl-sys-0.9.84
	overload-0.1.1
	parking-2.0.0
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	parse-zoneinfo-0.3.0
	password-hash-0.5.0
	paste-1.0.12
	pear-0.2.4
	pear_codegen-0.2.4
	pem-1.1.1
	percent-encoding-2.2.0
	pest-2.5.7
	pest_derive-2.5.7
	pest_generator-2.5.7
	pest_meta-2.5.7
	phf-0.11.1
	phf_codegen-0.11.1
	phf_generator-0.11.1
	phf_shared-0.11.1
	pico-args-0.5.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.26
	polling-2.6.0
	ppv-lite86-0.2.17
	pq-sys-0.4.7
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.55
	proc-macro2-diagnostics-0.10.0
	psl-types-2.0.11
	publicsuffix-2.2.3
	quanta-0.9.3
	quick-error-1.2.3
	quote-1.0.26
	quoted_printable-0.4.7
	r2d2-0.8.10
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	raw-cpuid-10.7.0
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	ref-cast-1.0.16
	ref-cast-impl-1.0.16
	regex-1.7.3
	regex-automata-0.1.10
	regex-syntax-0.6.29
	reqwest-0.11.16
	resolv-conf-0.7.0
	ring-0.16.20
	rmp-0.8.11
	rmpv-1.0.0
	rocket-0.5.0-rc.3
	rocket_codegen-0.5.0-rc.3
	rocket_http-0.5.0-rc.3
	rpassword-7.2.0
	rtoolbox-0.0.1
	rustix-0.37.6
	rustls-0.20.8
	rustls-pemfile-1.0.2
	rustversion-1.0.12
	ryu-1.0.13
	same-file-1.0.6
	schannel-0.1.21
	scheduled-thread-pool-0.2.7
	scoped-tls-1.0.1
	scopeguard-1.1.0
	scratch-1.0.5
	sct-0.7.0
	security-framework-2.8.2
	security-framework-sys-2.8.0
	semver-1.0.17
	serde-1.0.159
	serde_cbor-0.11.2
	serde_derive-1.0.159
	serde_json-1.0.95
	serde_urlencoded-0.7.1
	sha-1-0.10.1
	sha1-0.10.5
	sha2-0.10.6
	sharded-slab-0.1.4
	signal-hook-0.3.15
	signal-hook-registry-1.4.1
	simple_asn1-0.6.2
	siphasher-0.3.10
	slab-0.4.8
	smallvec-1.10.0
	socket2-0.4.9
	spin-0.5.2
	spin-0.9.7
	stable-pattern-0.1.0
	state-0.5.3
	strsim-0.10.0
	subtle-2.4.1
	syn-1.0.109
	syn-2.0.13
	syslog-6.0.1
	tempfile-3.5.0
	termcolor-1.2.0
	thiserror-1.0.40
	thiserror-impl-1.0.40
	thread_local-1.1.7
	threadpool-1.8.1
	time-0.3.20
	time-core-0.1.0
	time-macros-0.2.8
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.27.0
	tokio-macros-2.0.0
	tokio-native-tls-0.3.1
	tokio-rustls-0.23.4
	tokio-socks-0.5.1
	tokio-stream-0.1.12
	tokio-tungstenite-0.18.0
	tokio-util-0.7.7
	toml-0.5.11
	totp-lite-2.0.0
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-log-0.1.3
	tracing-subscriber-0.3.16
	trust-dns-proto-0.22.0
	trust-dns-resolver-0.22.0
	try-lock-0.2.4
	tungstenite-0.18.0
	typenum-1.16.0
	ubyte-0.10.3
	ucd-trie-0.1.5
	uncased-0.9.7
	unicode-bidi-0.3.13
	unicode-ident-1.0.8
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	unicode-xid-0.2.4
	untrusted-0.7.1
	url-2.3.1
	utf-8-0.7.6
	uuid-1.3.0
	valuable-0.1.0
	value-bag-1.0.0-alpha.9
	vcpkg-0.2.15
	version_check-0.9.4
	waker-fn-1.1.0
	walkdir-2.3.3
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-futures-0.4.34
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	wasm-streams-0.2.3
	web-sys-0.3.61
	webauthn-rs-0.3.2
	webpki-0.22.0
	which-4.4.0
	widestring-0.5.1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.44.0
	windows-0.46.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-targets-0.42.2
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_msvc-0.42.2
	windows_i686_gnu-0.42.2
	windows_i686_msvc-0.42.2
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_msvc-0.42.2
	winreg-0.10.1
	yansi-0.5.1
	yubico-0.11.0
"

inherit cargo systemd

DESCRIPTION="Unofficial Bitwarden compatible server written in Rust"
HOMEPAGE="https://github.com/dani-garcia/vaultwarden"

SRC_URI="
	https://github.com/dani-garcia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

LICENSE="
	0BSD AGPL-3 Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0
	GPL-3 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql postgres sqlite system-sqlite"
REQUIRED_USE=|| ( mysql postgres sqlite )
RESTRICT="mirror"

DEPEND="
	dev-libs/openssl:0=
	>=app-admin/vaultwarden-web-vault-2023.2.0
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite )
"
RDEPEND="
	${DEPEND}
	acct-group/vaultwarden
	acct-user/vaultwarden
"
BDEPEND=">=virtual/rust-1.67.1"

src_prepare() {
	if use system-sqlite; then
		sed -i -e '/^libsqlite3-sys =.*/s|features = \["bundled"\], ||' "Cargo.toml" || die
	fi

	default
}

src_configure() {
	myfeatures=(
		$(usev mysql)
		$(usex postgres postgresql '')
		$(usev sqlite)
	)

	cargo_src_configure --no-default-features
}

src_compile() {
	export VW_VERSION="${PV}"

	default
}

src_install() {
	cargo_src_install

	einstalldocs

	# Install init.d and conf.d scripts
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}.service"

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
