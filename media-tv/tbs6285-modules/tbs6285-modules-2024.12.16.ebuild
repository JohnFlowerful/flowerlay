# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# this ebuild is required because saa716x isn't in-tree

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel Modules for TBS DTV devices"
HOMEPAGE="https://www.tbsdtv.com/"

MEDIA_BUILD_COMMIT="3ae3e7dec33570a2c9a31fdc97890dd23fae460f"
# warning: these archives are snapshots with no versioning
SRC_URI="
	https://github.com/tbsdtv/media_build/archive/${MEDIA_BUILD_COMMIT}.tar.gz
		-> tbs_media_build-${MEDIA_BUILD_COMMIT}.tar.gz
	https://github.com/tbsdtv/media_build/releases/download/latest/linux-media.tar.bz2
		-> tbs_linux-media-${PV}.tar.bz2
	https://github.com/tbsdtv/media_build/releases/download/latest/dvb-firmwares.tar.bz2
		-> tbs_dvb-firmwares-${PV}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
CONFIG_CHECK="I2C_MUX REGMAP_I2C I2C_ALGOBIT"

BDEPEND="
	dev-perl/Proc-ProcessTable
	dev-util/patchutils
"

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
		unpack "tbs_linux-media-${PV}.tar.bz2"
	popd &>/dev/null || die

	mkdir "tbs_dvb-firmwares" || die
	pushd "tbs_dvb-firmwares" &>/dev/null || die
		unpack "tbs_dvb-firmwares-${PV}.tar.bz2"
	popd &>/dev/null || die
}

src_prepare() {
	sed -r -e "s|/sbin/lsmod|$(command -v lsmod)|" -i "v4l/Makefile" || die

	sed -r -e '/^print OUT "\\t\/sbin\/depmod -a/d' -i "v4l/scripts/make_makefile.pl" || die

	default
}

src_configure() {
	# when generating a config:
	# 'Autoselect ancillary drivers' must be selected otherwise CONFIG_I2C_MUX is
	# not set and the required modules will not be listed
	cp "${FILESDIR}/tbs6285.config" "v4l/.config" || die

	set_arch_to_kernel
}

src_compile() {
	emake VER="${KV_FULL}"
}

src_install() {
	emake DESTDIR="${ED}" VER="${KV_FULL}" install
	modules_post_process

	# install firmware
	insinto /lib/firmware
	pushd "${WORKDIR}/tbs_dvb-firmwares" &>/dev/null || die
		doins "dvb-demod-si2168-b40-01.fw"
		doins "dvb-demod-si2168-02.fw"
		doins "dvb-tuner-si2158-a20-01.fw"
	popd &>/dev/null || die
}
