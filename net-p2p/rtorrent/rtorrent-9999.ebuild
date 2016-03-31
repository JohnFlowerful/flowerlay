# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="https://github.com/rakshasa/rtorrent.git"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE="daemon debug ipv6 pyroscope selinux test xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-9999
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	ipv6? ( ~net-libs/libtorrent-9999[ipv6] )
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-util/cppunit )
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
		./autogen.sh
	fi

	# bug #358271
	# bug #462788 (reverted upstream)
	epatch \
		"${FILESDIR}"/${PN}-0.9.1-ncurses.patch \
		"${FILESDIR}"/${PN}-0.9.4-tinfo.patch
	
	if use pyroscope; then
		epatch \
			"${FILESDIR}"/ps-info-pane-xb-sizes_all.patch \
			"${FILESDIR}"/ps-item-stats-human-sizes_all.patch \
			"${FILESDIR}"/ps-throttle-steps_all.patch \
			"${FILESDIR}"/ps-ui_pyroscope_all.patch \
			"${FILESDIR}"/pyroscope.patch \
			"${FILESDIR}"/ui_pyroscope.patch

		cp ${FILESDIR}/{ui_pyroscope.{cc,h},command_pyroscope.cc} src
	fi
	
	if use ipv6; then
		epatch "${FILESDIR}"/${P}-ipv6.patch
	fi

	# upstream forgot to include
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	autoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
		systemd_newunit "${FILESDIR}/rtorrentd_at.service" "rtorrentd@.service"
	fi
}
