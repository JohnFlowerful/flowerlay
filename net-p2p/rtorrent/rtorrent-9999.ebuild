# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils systemd git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="https://github.com/rakshasa/rtorrent.git"
EGIT_BRANCH="feature-bind"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE="daemon debug pyroscope selinux test xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-9999
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
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
		"${FILESDIR}"/${PN}-0.9.6-ncurses.patch \
		"${FILESDIR}"/tinfo.patch \
		"${FILESDIR}"/backport_0.9.7_add_temp_filter-CH.patch
	
	if use pyroscope; then
		# fixed upstream: 
		#"${FILESDIR}"/ps-ssl_verify_hosts_all.patch \
		#"${FILESDIR}"/rt-base-cppunit-pkgconfig.patch \
		#"${FILESDIR}"/ps-fix-sort-started-stopped-views_all.patch \
		epatch \
			"${FILESDIR}"/ps-event-view_all.patch \
			"${FILESDIR}"/ps-fix-double-slash-319_all.patch \
			"${FILESDIR}"/ps-fix-throttle-args_all.patch \
			"${FILESDIR}"/ps-handle-sighup-578_all.patch \
			"${FILESDIR}"/ps-info-pane-xb-sizes_all.patch \
			"${FILESDIR}"/ps-issue-515_all.patch \
			"${FILESDIR}"/ps-item-stats-human-sizes_all.patch \
			"${FILESDIR}"/ps-log_messages_all.patch \
			"${FILESDIR}"/ps-throttle-steps_all.patch \
			"${FILESDIR}"/ps-ui_pyroscope_all.patch \
			"${FILESDIR}"/ps-view-filter-by_all.patch \
			"${FILESDIR}"/pyroscope.patch \
			"${FILESDIR}"/ui_pyroscope.patch

		cp ${FILESDIR}/{ui_pyroscope.{cc,h},command_pyroscope.cc} src
	fi

	# upstream forgot to include
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	eautoreconf
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
