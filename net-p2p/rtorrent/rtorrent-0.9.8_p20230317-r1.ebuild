# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-info tmpfiles

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"

RTORRENT_COMMIT="1da0e3476dcabbf74b2e836d6b4c37b4d96bde09"
SRC_URI="https://github.com/rakshasa/${PN}/archive/${RTORRENT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${RTORRENT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="daemon debug pyroscope selinux xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-0.13.$(ver_cut 3)
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/tmux )
	selinux? ( sec-policy/selinux-rtorrent )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

# fixed upstream:
# "${FILESDIR}/${PN}-0.9.8-bgo891995.patch"
# "${FILESDIR}/${PN}-0.9.8-configure-c99.patch"

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	default

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
		PATCHES+=(
			"${FILESDIR}/ps-import.return_all.patch"
			"${FILESDIR}/ps-info-pane-is-default_all.patch"
			"${FILESDIR}/ps-info-pane-xb-sizes_all.patch"
			"${FILESDIR}/ps-issue-515_all.patch"
			"${FILESDIR}/ps-item-stats-human-sizes_all.patch"
			"${FILESDIR}/ps-log_messages_all.patch"
			"${FILESDIR}/ps-object_std-map-serialization_all.patch"
			"${FILESDIR}/ps-silent-catch_all.patch"
			"${FILESDIR}/ps-ui_pyroscope_all.patch"
			"${FILESDIR}/pyroscope.patch"
			"${FILESDIR}/ui_pyroscope.patch"
		)

		cp "${FILESDIR}/ui_pyroscope."{cc,h} src || die
		cp "${FILESDIR}/command_pyroscope.cc" src || die
	fi

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 doc/ || die

	if [[ ${CHOST} != *-darwin* ]]; then
		# syslibroot is only for macos, change to sysroot for others
		sed -e 's/Wl,-syslibroot,/Wl,--sysroot,/' -i "scripts/common.m4" || die
	fi

	eautoreconf
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/861848
	# https://github.com/rakshasa/rtorrent/issues/1264
	filter-lto

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		$(use_enable debug) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/${PN}-r1.initd" "${PN}"
		newconfd "${FILESDIR}/${PN}-r1.confd" "${PN}"
		newtmpfiles - "${PN}.conf" <<-EOF
			d /run/${PN} 0775 root root
		EOF
	fi
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
