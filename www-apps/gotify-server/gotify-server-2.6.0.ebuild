# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="gotify"

inherit go-module

DESCRIPTION="A server for sending and receiving messages"
HOMEPAGE="https://gotify.net/"

# reuse old dep tarball
yarn_deps_ver="2.5.0"
SRC_URI="
	https://github.com/gotify/server/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.gz
	https://dandelion.ilypetals.net/dist/nodejs/${PN}-${yarn_deps_ver}-yarn_distfiles.tar.gz
"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="mysql postgres sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"
RESTRICT="mirror"

BDEPEND="
	>=dev-lang/go-1.22.4
	>=net-libs/nodejs-16
	>=sys-apps/yarn-1.9
"
RDEPEND="
	acct-group/gotify
	acct-user/gotify
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite )
"

S="${WORKDIR}/server-${PV}"

src_configure() {
	pushd "ui" &>/dev/null || die
		yarn config set disable-self-update-check true || die
		yarn config set nodedir /usr/include/node || die
		yarn config set yarn-offline-mirror "${WORKDIR}/yarn_distfiles" || die
		# puppeteer is a dev dependency used for tests
		export PUPPETEER_SKIP_DOWNLOAD=true

		yarn install --frozen-lockfile --offline --no-progress || die

		# workaround dev-libs/openssl-3 and md4. see https://github.com/webpack/webpack/issues/14560
		find node_modules/webpack/lib -type f -exec sed -i 's/md4/sha512/g' {} \; || die
		sed -e 's/crypto.createHash("md4")/crypto.createHash("sha512")/' \
			-i node_modules/react-scripts/node_modules/babel-loader/lib/cache.js || die
	popd &>/dev/null || die
}

src_compile() {
	# build ui
	einfo "Building web assets"
	pushd "ui" &>/dev/null || die
		yarn run build || die
	popd &>/dev/null || die

	# build binary
	einfo "Building application binary"
	local my_commit="$(zcat "${DISTDIR}/${P}.tar.gz" | git get-tar-commit-id)" || die
	local my_date=$(date "+%F-%T")
	ego build -o "${PN}" -trimpath -ldflags=" \
		-X main.Version=${PV} \
		-X main.Commit=${my_commit} \
		-X main.BuildDate=${my_date} \
		-X main.Mode=prod"
}

src_test() {
	ego test "./..."
}

src_install() {
	dobin "${PN}"
	insinto "/etc/${MY_PN}"
	newins "config.example.yml" "config.yml"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "/var/lib/${MY_PN}/data"
	fowners gotify:gotify "/var/lib/${MY_PN}/data"
	fperms 700 "/var/lib/${MY_PN}/data"

	einstalldocs
}
