# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd pnpm

DESCRIPTION="A modern web UI for various torrent clients"
HOMEPAGE="https://flood.js.org/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesec/${PN}.git"
	IUSE="+build-online"
else
	SRC_URI="
		https://github.com/jesec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		!build-online? ( https://dandelion.ilypetals.net/dist/nodejs/${P}-pnpm-deps.tar.gz )
	"
	IUSE="build-online"
	KEYWORDS="amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE+=" mediainfo"
PROPERTIES="build-online? ( live )"
RESTRICT="mirror"

BDEPEND=">=net-libs/nodejs-22"
RDEPEND="
	${BDEPEND}
	acct-group/flood
	acct-user/flood
	mediainfo? ( media-video/mediainfo )
"

# note: there's inconsistency in build methodology upstream
# the Dockerfile uses `npm run build` [1]. this file still uses a forked
# version of rtorrent where many of the features are now in mainline rtorrent
# so maybe safe to ignore
#
# conversely the workflow files for building debian .deb and publishing to
# the npm registry use `pnpm run build` [2][3]
#
# [1] https://github.com/jesec/flood/blob/master/Dockerfile
# [2] https://github.com/jesec/flood/blob/master/.github/workflows/build-debian.yml
# [3] https://github.com/jesec/flood/blob/master/.github/workflows/package.yml
PNPM_BUILD_SCRIPT="build"
# they're bundled with esbuild
NO_NODE_MODULES=1

src_unpack() {
	if use build-online; then
		unpack ${P}.tar.gz
	else
		pnpm_src_unpack
	fi
}

src_configure() {
	if use build-online; then
		pnpm install || die
		# `pnpm audit --fix` exits with a non-0 when there's breaking changes
		# play it safe: don't die and don't add '--force'
		pnpm audit --fix
	else
		pnpm_src_configure
	fi
}

src_prepare() {
	eapply_user

	# pnpm has no --no-foreground-scripts option for `pnpm pack`, so manually
	# remove these
	sed -e '/"prepack": .*$/d' \
		-e '/"prepare": .*$/d' \
		-i package.json || die
}

src_install() {
	pnpm_src_install

	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r dist

	newinitd "${FILESDIR}/${PN}-r2.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

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
