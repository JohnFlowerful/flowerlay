# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ZNC_DATADIR="${ZNC_DATADIR:-"/var/lib/znc"}"

DESCRIPTION="A ZNC module that will send notifications to multiple push notification services"
HOMEPAGE="https://github.com/jreese/znc-push"

SRC_URI="https://github.com/jreese/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="+curl"

BDEPEND=">=net-irc/znc-0.090:="
RDEPEND="curl? ( net-misc/curl )"

pkg_pretend() {
	if ! [[ -d "${EROOT}${ZNC_DATADIR}" ]]; then
		die "'${EROOT}${ZNC_DATADIR}' does not exist."
	fi
}

src_compile() {
	emake curl="$(usex curl)" version="${PV}"
}

src_install() {
	insinto "${ZNC_DATADIR}/modules"
	doins push.so
	fowners znc:znc "${ZNC_DATADIR}/modules/push.so"

	einstalldocs
}
