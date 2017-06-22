# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils libtool toolchain-funcs git-r3

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="https://github.com/rakshasa/libtorrent.git"
EGIT_BRANCH="feature-bind"

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

	epatch \
		"${FILESDIR}"/lt-ps-fix_horrible_interval_setters_0.13.2.patch \
		"${FILESDIR}"/lt-ps-honor_system_file_allocate_all.patch \
		"${FILESDIR}"/lt-ps-log_open_file-reopen_all.patch
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ssl openssl) \
		--with-posix-fallocate
}

src_install() {
	default

	prune_libtool_files --all
}
