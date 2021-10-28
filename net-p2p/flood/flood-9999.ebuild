# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A modern web UI for various torrent clients with a Node.js backend and React frontend."
HOMEPAGE="https://flood.js.org/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesec/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/jesec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

ACCT_DEPEND="
	acct-group/flood
	acct-user/flood
"
DEPEND="${ACCT_DEPEND}"
RDEPEND="${DEPEND}"
BDEPEND=">=net-libs/nodejs-14.17[npm]"

RESTRICT="mirror network-sandbox"

src_prepare() {
	npm ci --omit=optional

	eapply_user
}

src_compile() {
	npm audit fix

	npm run build
}

src_install() {
	insinto /usr/lib/flood
	doins -r *

	newinitd "${FILESDIR}"/flood.init ${PN}
	newconfd "${FILESDIR}"/flood.conf ${PN}
	systemd_newunit "${FILESDIR}"/flood_at.service ${PN}@.service

	keepdir /var/lib/flood
	fowners flood:flood /var/lib/flood
}

pkg_postinst() {
	if ! [[ -f "${EROOT}/var/lib/flood/flood.secret" ]]; then
		einfo "Flood will only listen to localhost by default."
		einfo "To listen for outside connections, add a --host directive to"
		einfo "the service file configuration"
		einfo
		einfo "See https://github.com/jesec/flood/blob/master/config.ts for"
		einfo "more configuration options"
	fi
}