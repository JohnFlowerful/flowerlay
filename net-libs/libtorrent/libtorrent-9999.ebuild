# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils libtool toolchain-funcs git-r3

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="https://github.com/rakshasa/libtorrent.git"
EGIT_BRANCH="feature-bind"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE="debug ssl"

RDEPEND="
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
#	epatch "${FILESDIR}"/download_constructor.diff
	elibtoolize
	if [[ ${PV} == *9999* ]]; then
		./autogen.sh
	fi
}

src_configure() {
	# the configure check for posix_fallocate is wrong.
	# reported upstream as Ticket 2416.
	local myconf
	echo "int main(){return posix_fallocate();}" > "${T}"/posix_fallocate.c
	if $(tc-getCC) ${CFLAGS} ${LDFLAGS} "${T}"/posix_fallocate.c -o /dev/null 2>/dev/null ; then
		myconf="--with-posix-fallocate"
	else
		myconf="--without-posix-fallocate"
	fi

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ssl openssl) \
		${myconf}
}
