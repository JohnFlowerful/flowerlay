# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# in chromium src: `git tag -l '*.0.${PV}.*' --sort=-v:refname`
# or check releases at https://github.com/bblanchon/pdfium-binaries
CHROMIUM_VERSION="156.0.${PV}.0"

BUILD_COMMIT="2cd94c0abeada712aeea6906d99021913c9fc28d"
ABSEIL_CPP_COMMIT="435e7d977fb36fb47854a4c552c0706dad0bd7cf"
DRAGONBOX_COMMIT="beeeef91cf6fef89a4d4ba5e95d47ca64ccb3a44"
GOOGLETEST_COMMIT="4fe3307fb2d9f86d19777c7eb0e4809e9694dde7"
TEST_FONTS_COMMIT="7f51783942943e965cd56facf786544ccfc07713"
# found in ${PN}-test_fonts-${TEST_FONTS_COMMIT}.tar.gz
CHROMIUM_FONTS="cd96fc55dc243f6c6f4cb63ad117cad6cd48dceb"

inherit ninja-utils

DESCRIPTION="Google's PDF rendering engine (standalone source build)"
HOMEPAGE="https://pdfium.googlesource.com"
SRC_URI="
	https://crunchday.io/dist/src/${P}.tar.gz
	https://crunchday.io/dist/src/${PN}-build-${BUILD_COMMIT}.tar.gz
	https://crunchday.io/dist/src/${PN}-abseil-cpp-${ABSEIL_CPP_COMMIT}.tar.gz
	https://github.com/jk-jeon/dragonbox/archive/${DRAGONBOX_COMMIT}.tar.gz
			-> ${PN}-dragonbox-${DRAGONBOX_COMMIT}.tar.gz
	https://raw.githubusercontent.com/chromium/chromium/refs/tags/${CHROMIUM_VERSION}/tools/generate_shim_headers/generate_shim_headers.py
		-> ${CHROMIUM_VERSION}_generate_shim_headers.py
	test? (
		https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
			-> ${PN}-googletest-${GOOGLETEST_COMMIT}.tar.gz
		https://crunchday.io/dist/src/${PN}-test_fonts-${TEST_FONTS_COMMIT}.tar.gz
		https://chromium-fonts.storage.googleapis.com/${CHROMIUM_FONTS}
			-> chromium-fonts-${CHROMIUM_FONTS}.tar.gz
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-build/gn
	test? (
		dev-cpp/gtest
		dev-cpp/simdutf
	)
"
DEPEND="
	dev-cpp/fast_float
	dev-libs/glib
	dev-libs/icu
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/lcms
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/openjpeg
	virtual/zlib
"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/public_headers.patch"
	"${FILESDIR}/shared_library.patch"
)

src_unpack() {
	# some tarballs are downloaded from googlesource.com, hence no parent
	# directory. unpack them manually
	# 1: archive 2: directory
	unpack_in_dir() {
		mkdir -p "${2}" || die
		pushd "${2}" >/dev/null || die
		unpack "${1}"
		popd >/dev/null || die
	}

	unpack_in_dir "${P}.tar.gz" "${S}"

	# build/ contains required GN templates/conf and python scripts
	unpack_in_dir "${PN}-build-${BUILD_COMMIT}.tar.gz" "${S}/build"

	# bundled abseil-cpp
	unpack_in_dir "${PN}-abseil-cpp-${ABSEIL_CPP_COMMIT}.tar.gz" "${S}/third_party/abseil-cpp"

	# bundled dragonbox
	unpack "${PN}-dragonbox-${DRAGONBOX_COMMIT}.tar.gz"
	mkdir -p "${S}/third_party/dragonbox" || die
	mv "dragonbox-${DRAGONBOX_COMMIT}" "${S}/third_party/dragonbox/src" || die

	if use test; then
		# gtest
		unpack "${PN}-googletest-${GOOGLETEST_COMMIT}.tar.gz"
		mkdir -p "${S}/third_party/googletest" || die
		mv "googletest-${GOOGLETEST_COMMIT}" "${S}/third_party/googletest/src" || die

		# test_fonts
		unpack_in_dir "${PN}-test_fonts-${TEST_FONTS_COMMIT}.tar.gz" "${S}/third_party/test_fonts"
		unpack_in_dir "chromium-fonts-${CHROMIUM_FONTS}.tar.gz" "${S}/third_party/test_fonts"
	fi

	# generate_shim_headers
	mkdir -p "${S}/tools/generate_shim_headers" || die
	cp "${DISTDIR}/${CHROMIUM_VERSION}_generate_shim_headers.py" \
		"${S}/tools/generate_shim_headers/generate_shim_headers.py" || die
}

src_prepare() {
	default

	# Unbundle packages
	local unbundle=(
		icu
		simdutf
	)

	for pkg in "${unbundle[@]}"; do
		mkdir -p third_party/"${pkg}" || die
		ln -sf "${S}/build/linux/unbundle/${pkg}.gn" "${S}/third_party/${pkg}/BUILD.gn" || die
	done

	# Use system fast_float
	mkdir -p third_party/fast_float/src/include/ || die
	ln -sf /usr/include/fast_float third_party/fast_float/src/include/ || die

	sed -i 's|script_executable = "//third_party/cpython3/host/bin/python3"|script_executable = "python3"|' .gn || die

	if ! use test; then
		# Remove test dependencies
		sed -i \
			-e '/\/\/third_party\/test_fonts/d' \
			-e '/\/\/third_party\/simdutf/d' \
			"${S}/testing/BUILD.gn" || die
	fi
}

src_configure() {
	echo "build_with_chromium = false" > "${S}/build/config/gclient_args.gni"

	# Define GN build arguments
	local gn_args=(
		"is_clang=false"
		"use_lld=false"
		"is_debug=false"
		"pdf_enable_v8=false"
		"pdf_enable_xfa=false"
		"is_component_build=false"
		"pdf_is_standalone=true"
		"treat_warnings_as_errors=false"
		"use_cxx23=false"
		"use_custom_libcxx=false"
		"use_glib=true"
		"pdf_use_partition_alloc=false"
		"pdf_use_skia=false"
		"use_sysroot=false"
		"use_system_freetype=true"
		"pdf_bundle_freetype=false"
		"use_siso=false"
		"use_system_harfbuzz=true"
		"use_system_lcms2=true"
		"use_system_libjpeg=true"
		"use_system_libopenjpeg2=true"
		"use_system_libpng=true"
		"use_system_zlib=true"
	)
	# Generate build files using GN
	gn gen out/Release --args="${gn_args[*]}" || die
}

src_compile() {
	local -a targets=( pdfium )
	if use test ; then
		targets+=( pdfium_unittests )
	fi

	eninja -C out/Release "${targets[@]}" || die
}

src_test() {
	local skip_tests=(
		# May fail with system zlib (produces different results)
		FlateModule.Encode
		# May fail with use_custom_libcxx=false
		RetainPtr.SetContains
	)
	local test_filter
	test_filter="-$(IFS=:; printf '%s' "${skip_tests[*]}")"

	out/Release/pdfium_unittests --gtest_filter="${test_filter}" || die "Tests failed!"
}

src_install() {
	# Manual installation of headers and library
	dolib.so out/Release/libpdfium.so

	insinto /usr/include/pdfium
	doins public/*.h
	insinto /usr/include/pdfium/cpp
	doins public/cpp/*.h

	dodir "/usr/$(get_libdir)/pkgconfig"
	sed \
		-e "s/@VERSION@/${CHROMIUM_VERSION}/" \
		"${FILESDIR}"/libpdfium.pc.in > "${ED}/usr/$(get_libdir)/pkgconfig/libpdfium.pc" || die
}
