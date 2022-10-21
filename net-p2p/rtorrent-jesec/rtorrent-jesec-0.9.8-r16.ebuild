# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic linux-info llvm systemd tmpfiles toolchain-funcs

MY_PV="${PV}-${PR}"
MY_PN="${PN/-jesec/}"

LLVM_MAX_SLOT=14

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://github.com/jesec/rtorrent"

if [[ ${MY_PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesec/rtorrent.git"
else
	SRC_URI="https://github.com/jesec/rtorrent/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="clang daemon debug jsonrpc lto pyroscope selinux test xmlrpc"

# cmake bombs when it cant find xmlrpc_server_abyss. this is included by
# xmlrpc-c whether the abyss use flag is enabled or not... build xmlrpc-c with
# abyss to work around this issue
BDEPEND="
	clang? ( 
		sys-devel/clang
		sys-devel/lld 
		net-libs/libtorrent-jesec[clang] )
	test? ( dev-cpp/gtest )"
COMMON_DEPEND="
	~net-libs/libtorrent-jesec-0.13.${PV##*.}
	>=net-misc/curl-7.19.1[adns]
	sys-libs/ncurses:0=
	jsonrpc? ( dev-cpp/nlohmann_json )
	xmlrpc? ( dev-libs/xmlrpc-c[abyss,cxx] )"
RDEPEND="
	${COMMON_DEPEND}
	!net-p2p/rtorrent
	daemon? ( app-misc/tmux )
	selinux? ( sec-policy/selinux-rtorrent )"
DEPEND="${COMMON_DEPEND}"

DOCS=( doc/rtorrent.rc )

RESTRICT="mirror !test? ( test )"

S=${WORKDIR}/${MY_PN}-${MY_PV}

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	cmake_src_prepare

	eapply "${FILESDIR}/ssl_verify_disable_list-${PVR}.patch"

	# fixed upstream:
	#"${FILESDIR}/${PN}-0.9.7-tinfo.patch" (bug #462788)
	#"${FILESDIR}/${PN}-0.9.7-execinfo-configure.patch"
	#"${FILESDIR}/backport_0.9.7_add_temp_filter-CH.patch"

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

		# unused
		#"${FILESDIR}/ps-silent-catch_all.patch" \
		eapply \
			"${FILESDIR}/ps-import.return_all.patch" \
			"${FILESDIR}/ps-info-pane-is-default_all.patch" \
			"${FILESDIR}/ps-info-pane-xb-sizes_all.patch" \
			"${FILESDIR}/ps-issue-515_all.patch" \
			"${FILESDIR}/ps-item-stats-human-sizes_all.patch" \
			"${FILESDIR}/ps-log_messages_all.patch" \
			"${FILESDIR}/ps-object_std-map-serialization_all.patch" \
			"${FILESDIR}/ps-ui_pyroscope_all.patch" \
			"${FILESDIR}/pyroscope.patch" \
			"${FILESDIR}/ui_pyroscope.patch"

		cp "${FILESDIR}/command_pyroscope.cc" "src"
		cp "${FILESDIR}/ui_pyroscope.cc" "src/ui/pyroscope.cc"
		cp "${FILESDIR}/ui_pyroscope.h" "include/ui/pyroscope.h"
	fi

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	default
}

src_configure() {
	# show flags set at the beginning
	einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"

	if use clang && ! tc-is-clang ; then
		# force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		AR=llvm-ar
		AS=llvm-as
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		strip-unsupported-flags
	elif ! use clang && ! tc-is-gcc ; then
		# force gcc
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
		strip-unsupported-flags
	fi

	# ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	# make user aware of flags set by this package during build time
	sed -i '/add_compile_options("-Wall" "-Wextra" "-Wpedantic")/s/^/#/' "${S}/CMakeLists.txt" || die
	append-cflags -Wall -Wextra -Wpedantic

	# ensure we're not building with potentially undesirable optimisation
	einfo "This ebuild does not use upstream's optimisation preference of -O3."
	sed -i '/add_compile_options("-O3")/s/^/#/' "${S}/CMakeLists.txt" || die

	# we'll handle debug later
	sed -i '/add_compile_options("-g")/s/^/#/' "${S}/CMakeLists.txt" || die

	local mycmakeargs=(
		-DUSE_JSONRPC=$(usex jsonrpc)
		-DUSE_XMLRPC=$(usex xmlrpc)
	)

	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
		mycmakeargs+=(
			-DUSE_EXTRA_DEBUG=$(usex debug)
		)

		# removing optimisations flags here is for aesthetics only
		sed -i '/add_compile_options("-Og")/s/^/#/' "${S}/CMakeLists.txt" || die
		filter-flags -O*
		append-flags -Og -g
	fi

	if use lto; then 
		append-flags -flto
		append-ldflags -flto -s
	fi

	# show flags we will use
	einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
		newtmpfiles "${FILESDIR}/rt_tmpfiles.conf" ${MY_PN}.conf
		systemd_newunit "${FILESDIR}/rtorrentd_at.service" "rtorrentd@.service"
	fi
}

pkg_postinst() {
	tmpfiles_process ${MY_PN}.conf
}
