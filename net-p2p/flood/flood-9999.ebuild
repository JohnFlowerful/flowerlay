# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A modern web UI for various torrent clients with a Node.js backend and React frontend"
HOMEPAGE="https://flood.js.org/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesec/${PN}.git"
	IUSE="+build-online"
	KEYWORDS=""
else
	SRC_URI="
		https://github.com/jesec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://dandelion.ilypetals.net/dist/nodejs/${P}-npm-cache.tar.xz
	"
	IUSE="build-online"
	KEYWORDS="amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE+=" mediainfo"

ACCT_DEPEND="
	acct-group/flood
	acct-user/flood
"
DEPEND="${ACCT_DEPEND}"
RDEPEND="
	${DEPEND}
	=net-libs/nodejs-16*[npm]
	mediainfo? ( media-video/mediainfo )
"

RESTRICT="mirror build-online? ( network-sandbox )"

src_prepare() {
	if ! use build-online; then
		# we're patching in an update to change sha1 to sha512 for this version.
		# run 'npm update' and diff package-lock.json to get the patch.
		# only required due to cache misses (integrity check failures) while offline
		eapply "${FILESDIR}/${P}-sha1_to_sha512.patch"
	fi

	default
}

src_configure() {
	if ! use build-online; then
		# remember to `npm cache add fsevents@$ver'...
		export npm_config_cache="${WORKDIR}/npm-cache"
	fi
	npm clean-install --legacy-peer-deps --omit=optional || die
}

src_compile() {
	if use build-online; then
		npm audit fix
	fi

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
