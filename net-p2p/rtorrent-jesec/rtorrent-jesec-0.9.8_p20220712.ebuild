# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-jesec/}"

inherit cmake flag-o-matic linux-info llvm tmpfiles toolchain-funcs

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://github.com/jesec/rtorrent"

RTORRENT_COMMIT="88fd968f3d78db55d50def1b973081359c547cb7"
SRC_URI="https://github.com/jesec/${MY_PN}/archive/${RTORRENT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE="clang daemon debug jsonrpc lto pyroscope selinux test xmlrpc"
RESTRICT="mirror !test? ( test )"

# cmake bombs when it cant find xmlrpc_server_abyss. this is included by
# xmlrpc-c whether the abyss use flag is enabled or not... build xmlrpc-c with
# abyss to work around this issue
COMMON_DEPEND="
	~net-libs/libtorrent-jesec-0.13.$(ver_cut 3)
	>=net-misc/curl-7.88.0[adns]
	sys-libs/ncurses:0=
	jsonrpc? ( dev-cpp/nlohmann_json )
	xmlrpc? ( dev-libs/xmlrpc-c[abyss,cxx] )
"
BDEPEND="
	${COMMON_DEPEND}
	clang? (
		sys-devel/clang
		sys-devel/lld
		net-libs/libtorrent-jesec[clang]
	)
	test? ( dev-cpp/gtest )
"
RDEPEND="
	${COMMON_DEPEND}
	!net-p2p/rtorrent
	daemon? ( app-misc/tmux )
	selinux? ( sec-policy/selinux-rtorrent )
"

DOCS=( doc/rtorrent.rc )

PATCHES=(
	# https://github.com/jesec/rtorrent/pull/46
	"${FILESDIR}/${MY_PN}-deprecated_func.patch"
	# https://github.com/jesec/rtorrent/pull/59
	"${FILESDIR}/${MY_PN}-unqualified_move.patch"
)

S="${WORKDIR}/${MY_PN}-${RTORRENT_COMMIT}"

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	if use pyroscope; then
		PATCHES+=(
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
			#"${FILESDIR}/ps-silent-catch_all.patch"

			"${FILESDIR}/ps-import.return_all.patch"
			"${FILESDIR}/ps-info-pane-is-default_all.patch"
			"${FILESDIR}/ps-info-pane-xb-sizes_all.patch"
			"${FILESDIR}/ps-issue-515_all.patch"
			"${FILESDIR}/ps-item-stats-human-sizes_all.patch"
			"${FILESDIR}/ps-log_messages_all.patch"
			"${FILESDIR}/ps-object_std-map-serialization_all.patch"
			"${FILESDIR}/ps-ui_pyroscope_all.patch"
			"${FILESDIR}/pyroscope.patch"
			"${FILESDIR}/ui_pyroscope.patch"
		)

		cp "${FILESDIR}/command_pyroscope.cc" "src" || die
		cp "${FILESDIR}/ui_pyroscope.cc" "src/ui/pyroscope.cc" || die
		cp "${FILESDIR}/ui_pyroscope.h" "include/ui/pyroscope.h" || die
	fi

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 doc/ || die

	cmake_src_prepare
}

src_configure() {
	# show flags set at the beginning
	einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"

	local have_switched_compiler=
	if use clang; then
		# force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		if tc-is-gcc; then
			have_switched_compiler=yes
		fi
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	# ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	# make user aware of flags set by this package during build time
	sed -e '/add_compile_options("-Wall" "-Wextra" "-Wpedantic")/s/^/#/' -i "CMakeLists.txt" || die
	append-cflags -Wall -Wextra -Wpedantic

	# ensure we're not building with potentially undesirable optimisation
	einfo "This ebuild does not use upstream's optimisation preference of -O3."
	sed -e '/add_compile_options("-O3")/s/^/#/' -i "CMakeLists.txt" || die

	# we'll handle debug later
	sed -e '/add_compile_options("-g")/s/^/#/' -i "CMakeLists.txt" || die

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
		sed -e '/add_compile_options("-Og")/s/^/#/' -i "CMakeLists.txt" || die
		filter-flags -O*
		append-flags -Og -g
	fi

	if use lto; then
		append-flags -flto
		append-ldflags -flto -s
		QA_PRESTRIPPED+="usr/bin/${MY_PN}"
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
		newinitd "${FILESDIR}/${MY_PN}.initd" "${MY_PN}"
		newconfd "${FILESDIR}/${MY_PN}.confd" "${MY_PN}"
		newtmpfiles - "${MY_PN}.conf" <<-EOF
			d /run/${MY_PN} 0775 root root
		EOF
	fi

	einstalldocs
}

pkg_postinst() {
	tmpfiles_process "${MY_PN}.conf"
}
