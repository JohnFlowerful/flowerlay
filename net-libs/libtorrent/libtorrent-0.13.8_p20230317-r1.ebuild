# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"

LIBTORRENT_COMMIT="91f8cf4b0358d9b4480079ca7798fa7d9aec76b5"
SRC_URI="https://github.com/rakshasa/${PN}/archive/${LIBTORRENT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${LIBTORRENT_COMMIT}"

LICENSE="GPL-2"
# The README says that the library ABI is not yet stable and dependencies on
# the library should be an explicit, syncronized version until the library
# has had more time to mature. Until it matures we should not include a soname
# subslot.
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug ssl test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/zlib
	ssl? ( dev-libs/openssl:= )
	test? ( dev-util/cppunit:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# fixed upstream:
# "${FILESDIR}"/${PN}-0.13.8-configure-clang-16.patch
PATCHES=(
	"${FILESDIR}/${PN}-sysroot.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 518582
	local disable_instrumentation
	echo -e "#include <inttypes.h>\nint main(){ int64_t var = 7; __sync_add_and_fetch(&var, 1); return 0;}" > "${T}/sync_add_and_fetch.c" || die
	$(tc-getCC) ${CFLAGS} -o /dev/null -x c "${T}/sync_add_and_fetch.c" >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		einfo "Disabling instrumentation"
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

	find "${ED}" -type f -name '*.la' -delete || die
}
