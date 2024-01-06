# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modern web UI for various torrent clients"
HOMEPAGE="https://flood.js.org/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesec/${PN}.git"
	IUSE="+build-online"
else
	FLOOD_COMMIT="748195a21bf5bb32e46c87e96898ae6ad824a07c"
	SRC_URI="
		https://github.com/jesec/${PN}/archive/${FLOOD_COMMIT}.tar.gz -> ${P}.tar.gz
		https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-cache.tar.xz
	"
	IUSE="build-online"
	KEYWORDS="amd64"
	S="${WORKDIR}/${PN}-${FLOOD_COMMIT}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE+=" mediainfo"
RESTRICT="build-online? ( network-sandbox ) mirror"

BDEPEND=">=net-libs/nodejs-18[npm]"
RDEPEND="
	${BDEPEND}
	acct-group/flood
	acct-user/flood
	mediainfo? ( media-video/mediainfo )
"

src_configure() {
	if ! use build-online; then
		export npm_config_cache="${WORKDIR}/npm-cache"
	fi

	npm clean-install --omit=optional || die
}

src_compile() {
	if use build-online; then
		# 'npm audit fix' exits with a non-0 when there's breaking changes
		# play it safe: don't die and don't add '--force'
		npm audit fix
	fi

	npm run build || die
}

src_install() {
	insinto "/usr/lib/${PN}"
	doins -r *

	newinitd "${FILESDIR}/${PN}-r1.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "/var/lib/${PN}"
	fowners flood:flood "/var/lib/${PN}"

	einstalldocs
}

pkg_postinst() {
	if ! [[ -f "${EROOT}/var/lib/flood/flood.secret" ]]; then
		einfo "Flood will only listen on localhost by default."
		einfo "To listen for outside connections, add a --host directive to"
		einfo "the service file configuration"
		einfo
		einfo "See https://github.com/jesec/flood/blob/master/config.ts for"
		einfo "more configuration options"
	fi
}
