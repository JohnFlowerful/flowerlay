# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3

DESCRIPTION="A ZNC module that will send notifications to multiple push notification services"
EGIT_REPO_URI="https://github.com/jreese/znc-push.git"
HOMEPAGE="https://github.com/jreese/znc-push"

LICENSE="MIT"
SLOT="0"
IUSE="+curl"

RDEPEND="
	curl? ( net-misc/curl )
"
DEPEND="${RDEPEND}
	>=net-irc/znc-0.090
"

ZNC_DATADIR="${ZNC_DATADIR:-"/var/lib/znc"}"

src_prepare() {
	epatch "${FILESDIR}"/destdir.patch
}

src_compile() {
	curl="no"
	if use curl; then
		curl="yes"
	fi
	emake curl=${curl}
}

src_install() {
	if [[ -d "${EROOT}${ZNC_DATADIR}" ]]; then
		elog "Copying module to ${ZNC_DATADIR}/modules"
		emake DESTDIR="${D}/${ZNC_DATADIR}" install
		chown -R znc:znc "${D}/${ZNC_DATADIR}/modules/push.so"
	else
		ewarn "${ZNC_DATADIR} doesn't exist, aborting."
	fi
}