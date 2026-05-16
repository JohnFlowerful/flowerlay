# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel Modules for TBS DTV devices"
HOMEPAGE="https://www.tbsdtv.com/"

SRC_URI="https://www.tbsiptv.com/download/common/tbsdvb_v${PV}.tar.bz2"

S="${WORKDIR}/tbsdvb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
# tbs make modifications to DVB_CORE, so be sure to use their module
CONFIG_CHECK="I2C_MUX REGMAP_I2C I2C_ALGOBIT ~!DVB_CORE"

PATCHES=(
	"${FILESDIR}/tbsdvb_${PV}_restore_reachable.patch"
)

pkg_setup() {
	linux-mod-r1_pkg_setup
	get_version
}

src_prepare() {
	default

	# why is all here??
	sed -i 's/install: all/install:/' Makefile || die
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	local mods=(DVB_CORE DVB_TBSECP3 DVB_CXD2878)
	local moddefs=$(printf " CONFIG_%s=m" "${mods[@]}")
	export EXTRA_CFLAGS+=$(printf " -DCONFIG_%s_MODULE=1" "${mods[@]}")

	emake kernelver="${KV_FULL}" MODDEFS="${moddefs}" all
}

src_install() {
	emake kernelver="${KV_FULL}" MDIR="${ED}" install
	modules_post_process
}
