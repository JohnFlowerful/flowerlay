# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# this ebuild is required because saa716x isn't in-tree

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel Modules for TBS DTV devices"
HOMEPAGE="https://www.tbsdtv.com/"

MEDIA_BUILD_COMMIT="ff326ab69e786d447a0e0e967cb45acb5d5ca9ff"
TBS_LINUX_MEDIA_COMMIT="4bf556a6bcf1154c5178f6bf15ef3094851c2f34"
SRC_URI="
	https://github.com/tbsdtv/media_build/archive/${MEDIA_BUILD_COMMIT}.tar.gz
		-> tbs_media_build-${MEDIA_BUILD_COMMIT}.tar.gz
	https://dandelion.ilypetals.net/dist/src/tbs_linux-media-${TBS_LINUX_MEDIA_COMMIT}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
# it looks like tbs make modifications to DVB_CORE, so use their module instead
CONFIG_CHECK="I2C_MUX REGMAP_I2C I2C_ALGOBIT ~!DVB_CORE"
BDEPEND="
	dev-perl/Proc-ProcessTable
	dev-util/patchutils
"

PATCHES=(
	"${FILESDIR}/${PV}-EXTRA_CFLAGS.patch"
	"${FILESDIR}/${PV}-timer_delete.patch"
	"${FILESDIR}/${PV}-timer_container_of.patch"
	"${FILESDIR}/${PV}-align_down.patch"
)

pkg_setup() {
	linux-mod-r1_pkg_setup
	get_version
}

src_unpack() {
	# avoid the `unpack` helper so we can use --strip-components on tar
	mkdir -p "${P}" || die
	tar -C ${P} --strip-components 1 --no-same-owner \
		-zxf "${DISTDIR}/tbs_media_build-${MEDIA_BUILD_COMMIT}.tar.gz" || die

	pushd "${P}/linux" &>/dev/null || die
		unpack "tbs_linux-media-${TBS_LINUX_MEDIA_COMMIT}.tar.bz2"
	popd &>/dev/null || die
}

src_prepare() {
	sed -r -e "s|/sbin/lsmod|$(command -v lsmod)|" -i "v4l/Makefile" || die

	sed -r -e '/^print OUT "\\t\/sbin\/depmod -a/d' -i "v4l/scripts/make_makefile.pl" || die

	default
}

src_configure() {
	cp "${FILESDIR}/tbs6209se.config" "v4l/.config" || die

	set_arch_to_kernel
}

src_compile() {
	emake VER="${KV_FULL}"
}

src_install() {
	emake DESTDIR="${ED}" VER="${KV_FULL}" install
	modules_post_process
}
