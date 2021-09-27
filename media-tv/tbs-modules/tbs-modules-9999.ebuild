# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils linux-mod git-r3

DESCRIPTION="Kernel Modules for TBS DTV devices"
HOMEPAGE="https://www.tbsdtv.com/"
GIT_REPO_MEDIA_BUILD="https://github.com/tbsdtv/media_build.git"
GIT_REPO_LINUX_MEDIA="https://github.com/tbsdtv/linux_media.git"
GIT_LINUX_MEDIA_BRANCH="latest"

CONFIG_CHECK="I2C_MUX REGMAP_I2C I2C_ALGOBIT"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-perl/Proc-ProcessTable
	dev-util/patchutils"

S="${WORKDIR}/media_build"

export DESTDIR="${ED}"

pkg_setup() {
	get_version
	linux-mod_pkg_setup
}

src_unpack() {
	git-r3_fetch ${GIT_REPO_MEDIA_BUILD} refs/heads/master
	git-r3_checkout ${GIT_REPO_MEDIA_BUILD} "${WORKDIR}/media_build"

	git-r3_fetch ${GIT_REPO_LINUX_MEDIA} refs/heads/${GIT_LINUX_MEDIA_BRANCH}
	git-r3_checkout ${GIT_REPO_LINUX_MEDIA} "${WORKDIR}/media"

	cp "${FILESDIR}/v4l.config" "${WORKDIR}/media_build/v4l/.config"
}

src_prepare() {
	sed -i -r "/^OUTDIR \?= \//i KERNELRELEASE = ${KV_FULL}" "${WORKDIR}/media_build/v4l/Makefile" || die
	sed -i -r "/^OUTDIR \?= / s|/.+|${KERNEL_DIR}|" "${WORKDIR}/media_build/v4l/Makefile" || die
	lsmod=$(command -v lsmod)
	sed -i -r "s|/sbin/lsmod|${lsmod}|" "${WORKDIR}/media_build/v4l/Makefile" || die

	sed -i -r '/^print OUT "\\t\/sbin\/depmod -a/d' "${WORKDIR}/media_build/v4l/scripts/make_makefile.pl" || die

	eapply_user
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	emake dir DIR=../media
	emake
}

src_install() {
	emake install
}
