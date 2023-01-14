# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)"
HOMEPAGE="https://gotify.net/"

SRC_URI="
	https://github.com/gotify/server/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-go-mod.tar.xz
	https://dandelion.ilypetals.net/dist/nodejs/${P}-yarn_distfiles.tar.xz
"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
IUSE="mysql postgres sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"
KEYWORDS="amd64"

ACCT_DEPEND="
	acct-group/gotify
	acct-user/gotify
"
DEPEND="${ACCT_DEPEND}"
BDEPEND="
	>=dev-lang/go-1.16.0
	=net-libs/nodejs-16*
	sys-apps/yarn
"
RDEPEND="
	${DEPEND}
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite )
"

RESTRICT="mirror"

S="${WORKDIR}/server-${PV}"

src_configure() {
	ebegin "Installing node_modules"
	pushd "${S}/ui" > /dev/null || die
		yarn config set disable-self-update-check true || die
		yarn config set nodedir /usr/include/node || die
		yarn config set yarn-offline-mirror "${WORKDIR}/yarn_distfiles" || die
		# puppeteer is a dev dependency used for tests
		export PUPPETEER_SKIP_DOWNLOAD=true
		yarn install --frozen-lockfile --offline --no-progress || die
		# workaround md4 see https://github.com/webpack/webpack/issues/14560
		find node_modules/webpack/lib -type f -exec sed -i 's/md4/sha512/g' {} \; || die
		sed -i 's/crypto.createHash("md4")/crypto.createHash("sha512")/' node_modules/react-scripts/node_modules/babel-loader/lib/cache.js || die
	popd > /dev/null || die
	eend $? || die
}

src_compile() {
	# build ui and then generate static assets for go
	einfo "Building web assets"
	pushd "${S}/ui" > /dev/null || die
		yarn run build || die
	popd > /dev/null || die
	go run hack/packr/packr.go -- . || die

	# build binary
	einfo "Building application binary"
	MY_COMMIT="$(zcat ${DISTDIR}/${P}.tar.gz | git get-tar-commit-id)" || die
	MY_DATE=$(date "+%F-%T")
	go build \
		-o ${PN} \
		-trimpath \
		-ldflags="-X 'main.Version=${PV}' \
			-X 'main.Commit=${MY_COMMIT}' \
			-X 'main.BuildDate=${MY_DATE}' \
			-X 'main.Mode=prod'" || die
}

src_install() {
	dobin ${PN}
	insinto "/etc/gotify"
	newins "config.example.yml" "config.yml"
	dodoc "LICENSE"

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service

	keepdir /var/lib/gotify/data
	fowners gotify:gotify /var/lib/gotify/data
	fperms 700 /var/lib/gotify/data
}