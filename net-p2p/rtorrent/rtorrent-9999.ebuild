# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils linux-info systemd git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="https://github.com/rakshasa/rtorrent.git"
EGIT_BRANCH="feature/bind-merge"

LICENSE="GPL-2"
SLOT="0"
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

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
		./autogen.sh
	fi

	# fixed upstream:
	#"${FILESDIR}/${PN}-0.9.7-tinfo.patch" (bug #462788)
	#"${FILESDIR}/${PN}-0.9.7-execinfo-configure.patch"
	#"${FILESDIR}/backport_0.9.7_add_temp_filter-CH.patch"
	epatch \
		"${FILESDIR}/${PN}-0.9.6-ncurses.patch" # bug #358271

	if use pyroscope; then
		# fixed upstream:
		#"${FILESDIR}/ps-dl-ui-find_all.patch"
		#"${FILESDIR}/ps-event-view_all.patch"
		#"${FILESDIR}/ps-fix-double-slash-319_all.patch"
		#"${FILESDIR}/ps-fix-log-xmlrpc-close_all.patch"
		#"${FILESDIR}/ps-fix-sort-started-stopped-views_all.patch"
		#"${FILESDIR}/ps-fix-throttle-args_all.patch"
		#"${FILESDIR}/ps-handle-sighup-578_all.patch"
		#"${FILESDIR}/ps-ssl_verify_hosts_all.patch"
		#"${FILESDIR}/ps-throttle-steps_all.patch"
		#"${FILESDIR}/ps-view-filter-by_all.patch"
		#"${FILESDIR}/rt-base-cppunit-pkgconfig.patch"
		epatch \
			"${FILESDIR}/ps-import.return_all.patch" \
			"${FILESDIR}/ps-info-pane-is-default_all.patch" \
			"${FILESDIR}/ps-info-pane-xb-sizes_all.patch" \
			"${FILESDIR}/ps-issue-515_all.patch" \
			"${FILESDIR}/ps-item-stats-human-sizes_all.patch" \
			"${FILESDIR}/ps-log_messages_all.patch" \
			"${FILESDIR}/ps-object_std-map-serialization_all.patch" \
			"${FILESDIR}/ps-silent-catch_all.patch" \
			"${FILESDIR}/ps-ui_pyroscope_all.patch" \
			"${FILESDIR}/pyroscope.patch" \
			"${FILESDIR}/ui_pyroscope.patch"

		cp ${FILESDIR}/{ui_pyroscope.{cc,h},command_pyroscope.cc} src
	fi

	# https://github.com/rakshasa/rtorrent/issues/332
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
