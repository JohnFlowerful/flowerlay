# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm multilib

MODEL="dcpj1100dw"
MY_PV="$(ver_cut 1-3)-${PR/r/}"

DESCRIPTION="Brother printer drive for ${MODEL}"
HOMEPAGE="https://support.brother.com/g/b/producttop.aspx?c=nz&lang=en&prod=dcpj1100dw_eu_as"

SRC_URI="https://download.brother.com/welcome/dlf103810/${MODEL}pdrv-${MY_PV}.i386.rpm"

LICENSE="Brother"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+metric scanner"
RESTRICT="bindist mirror strip"

DEPEND="net-print/cups"
RDEPEND="
	${DEPEND}
	scanner? ( media-gfx/brscan4 )
	app-text/ghostscript-gpl
	app-text/a2ps
"

DEST="/opt/brother/Printers/${MODEL}"
S="${WORKDIR}${DEST}"

pkg_pretend() {
	if ! has_multilib_profile; then
		die "This package requires a multilib profile"
	fi
}

src_prepare() {
	if use metric; then
		sed -e '/^PaperType/s/Letter/A4/' -i "inf/br${MODEL}rc" || die
	fi

	default
}

src_install() {
	insinto "${DEST}"
	doins -r inf

	exeinto "${DEST}/lpd"
	doexe lpd/*

	# printer configuration utility
	dobin "${WORKDIR}/usr/bin/brprintconf_${MODEL}"

	# install wrapping tools for CUPS
	exeinto "${DEST}/cupswrapper"
	doexe "cupswrapper/cupswrapper${MODEL}"

	# you have to install the cupswrapper where it wants to be and then symbolically
	# link to it; otherwise the $basedir that is assumed in the script generates
	# confused paths
	exeinto "${DEST}/cupswrapper"
	doexe "cupswrapper/brother_lpdwrapper_${MODEL}"
	mkdir -p "${D}/usr/libexec/cups/filter" || die
	ln -s "${D}${DEST}/cupswrapper/brother_lpdwrapper_${MODEL}" "${D}/usr/libexec/cups/filter/brother_lpdwrapper_${MODEL}" || die

	insinto usr/share/ppd/Brother
	doins "cupswrapper/brother_${MODEL}_printer_en.ppd"
}
