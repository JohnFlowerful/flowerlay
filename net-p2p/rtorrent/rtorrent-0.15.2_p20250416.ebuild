# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info tmpfiles

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"

RTORRENT_COMMIT="dd221ac66a7cdb2f7cf3ebc2a44084a6b0ead171"
SRC_URI="https://github.com/rakshasa/${PN}/archive/${RTORRENT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${RTORRENT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug lua selinux test tinyxml2 xmlrpc"
RESTRICT="!test? ( test )"
REQUIRED_USE="tinyxml2? ( !xmlrpc )"

DEPEND="
	=net-libs/libtorrent-$(ver_cut 1).$(ver_cut 2).$(ver_cut 3)*
	net-misc/curl
	sys-libs/ncurses:0=
	lua? ( >=dev-lang/lua-5.4:= )
	xmlrpc? ( dev-libs/xmlrpc-c:= )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rtorrent )
"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

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
	default

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	if [[ ${CHOST} != *-darwin* ]]; then
		# syslibroot is only for macos, change to sysroot for others
		sed -i 's/Wl,-syslibroot,/Wl,--sysroot,/' "${S}/scripts/common.m4" || die
	fi

	eautoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		$(use_enable debug) \
		$(usev lua --with-lua) \
		$(usev xmlrpc --with-xmlrpc-c) \
		$(usev tinyxml2 --with-xmlrpc-tinyxml2)
}

src_install() {
	default
	doman doc/rtorrent.1

	newinitd "${FILESDIR}/${PN}-r1.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-r1.confd" "${PN}"
	newtmpfiles - "${PN}.conf" <<-EOF
		d /run/${PN} 0775 root root
	EOF
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
