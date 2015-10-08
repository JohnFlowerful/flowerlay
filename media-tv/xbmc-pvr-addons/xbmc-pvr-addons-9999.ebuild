# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
# A well-used example of an eclass function that needs eutils is epatch. If
# your source needs patches applied, it's suggested to put your patch in the
# 'files' directory and use:
#
#   epatch "${FILESDIR}"/patch-name-here
#
# eclasses tend to list descriptions of how to use their functions properly.
# take a look at /usr/portage/eclass/ for more examples.

inherit git-r3 autotools multilib

DESCRIPTION="PVR addons for XBMC"
HOMEPAGE="https://github.com/adamsutton/xbmc-pvr-addons"
EGIT_REPO_URI="git://github.com/adamsutton/xbmc-pvr-addons.git"

LICENSE="GPLv3"
SLOT="0"
IUSE="zip"

DEPEND="zip? ( >=app-arch/zip-3.0 )"
RDEPEND="${DEPEND}"

src_configure() {
	./bootstrap
	econf --prefix=/usr \
			--libdir=/usr/share/kodi/addons \
			--datadir=/usr/share/kodi/addons
}

src_install() {
	emake DESTDIR="${D}" install || die eerror "emake install failed"
}
