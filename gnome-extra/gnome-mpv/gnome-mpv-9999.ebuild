# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$ 

EAPI=5
inherit fdo-mime autotools gnome2-utils git-r3

DESCRIPTION="A GTK+ interface to MPV"
HOMEPAGE="https://github.com/gnome-mpv/gnome-mpv/"
EGIT_REPO_URI="https://github.com/gnome-mpv/gnome-mpv.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.30
	>=x11-libs/gtk+-3.10:3
	x11-libs/libX11"
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
	media-video/mpv[libmpv]"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="README.md"

src_prepare() {
	sed -i '/$(UPDATE_DESKTOP)/d' Makefile.am || die
	sed -i '/$(UPDATE_ICON)/d' Makefile.am || die
	sed -i '/install-data-hook:/d' Makefile.am || die
	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
