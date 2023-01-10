# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools cmake flag-o-matic llvm toolchain-funcs

MY_PV="${PV}-${PR}"
MY_PN="${PN/-jesec/}"

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://github.com/jesec/libtorrent"

if [[ ${MY_PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesec/libtorrent.git"
else
	SRC_URI="https://github.com/jesec/libtorrent/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="clang debug lto test"

BDEPEND="
	clang? ( sys-devel/clang sys-devel/lld )
	test? ( dev-cpp/gtest )"
RDEPEND="
	dev-libs/openssl:0=
	!net-libs/libtorrent
	sys-libs/zlib"
DEPEND="${RDEPEND}"

RESTRICT="mirror !test? ( test )"

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_prepare() {
	cmake_src_prepare

	# patches from https://github.com/pyroscope/rtorrent-ps/tree/master/patches
	# fixed upstream:
	#"${FILESDIR}"/lt-base-c11-fixes.patch
	#"${FILESDIR}"/lt-base-cppunit-pkgconfig.patch
	#"${FILESDIR}"/lt-open-ssl-1.1.patch
	#"${FILESDIR}"/lt-ps-fix_horrible_interval_setters_0.13.2.patch
	#"${FILESDIR}"/lt-ps-honor_system_file_allocate_all.patch
	#"${FILESDIR}"/lt-ps-log_open_file-reopen_all.patch
	eapply "${FILESDIR}"/lt-ps-better-bencode-errors_all.patch
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
		-DBUILD_TESTS=$(usex test)
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
