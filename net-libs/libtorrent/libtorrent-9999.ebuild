# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils libtool toolchain-funcs git-r3

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="https://github.com/rakshasa/libtorrent.git"
EGIT_BRANCH="feature/bind-merge"

LICENSE="GPL-2"

# The README says that the library ABI is not yet stable and dependencies on
# the library should be an explicit, syncronized version until the library
# has had more time to mature. Until it matures we should not include a soname
# subslot.
SLOT="0"

IUSE="debug libressl ssl test"

RDEPEND="
	sys-libs/zlib
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cppunit )"

src_prepare() {
	elibtoolize
	if [[ ${PV} == *9999* ]]; then
		./autogen.sh
	fi

	# fixed upstream:
	# "${FILESDIR}"/lt-ps-log_open_file-reopen_all.patch
	epatch \
		"${FILESDIR}"/lt-ps-honor_system_file_allocate_all.patch \
		"${FILESDIR}"/lt-ps-better-bencode-errors_all.patch
}

src_configure() {
	# bug 518582
	local disable_instrumentation
	echo -e "#include <inttypes.h>\nint main(){ int64_t var = 7; __sync_add_and_fetch(&var, 1); return 0;}" > "${T}/sync_add_and_fetch.c" || die
	$(tc-getCC) ${CFLAGS} -o /dev/null -x c "${T}/sync_add_and_fetch.c" >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		disable_instrumentation="--disable-instrumentation"
	fi

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ssl openssl) \
		${disable_instrumentation} \
		--with-posix-fallocate
}

src_install() {
	default

	prune_libtool_files --all
}
