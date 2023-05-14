# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic llvm toolchain-funcs

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
RESTRICT="mirror !test? ( test )"

RDEPEND="
	dev-libs/openssl:=
	!net-libs/libtorrent
	sys-libs/zlib
"
BDEPEND="
	clang? ( sys-devel/clang sys-devel/lld )
	test? ( dev-cpp/gtest )
"

PATCHES=(
	# https://github.com/jesec/libtorrent/pull/8
	"${FILESDIR}/${MY_PN}-deprecated_func.patch"
)

S="${WORKDIR}/${MY_PN}-${MY_PV}"

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
		-DBUILD_TESTS=$(usex test)
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
		QA_PRESTRIPPED+="usr/lib64/${MY_PN}.so.*"
	fi

	# show flags we will use
	einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"

	cmake_src_configure
}
