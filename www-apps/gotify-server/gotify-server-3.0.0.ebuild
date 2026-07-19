# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="gotify"

inherit go-module systemd

DESCRIPTION="A server for sending and receiving messages"
HOMEPAGE="https://gotify.net/"

SRC_URI="
	https://github.com/gotify/server/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/go/${P}-vendor.tar.xz
	https://dandelion.ilypetals.net/dist/nodejs/${P}-yarn-deps.tar.gz
"

S="${WORKDIR}/server-${PV}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64"
IUSE="mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"
RESTRICT="mirror"

BDEPEND="
	>=dev-lang/go-1.25.0
	>=net-libs/nodejs-16
	>=sys-apps/yarn-1.9
"
RDEPEND="
	acct-group/gotify
	acct-user/gotify
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite )
"

src_configure() {
	yarn config set disable-self-update-check true || die
	yarn config set nodedir /usr/include/node || die
	yarn config set yarn-offline-mirror "${WORKDIR}/yarn-deps" || die
	# puppeteer is a dev dependency used for tests
	export PUPPETEER_SKIP_DOWNLOAD=true

	yarn --cwd ui/ \
		--frozen-lockfile \
		--offline \
		--no-progress \
		install || die
}

src_compile() {
	# build ui
	einfo "Building web assets"
	yarn --cwd ui/ run build || die

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
	newins "${PN}.env.example" "${PN}.env"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir "/var/lib/${MY_PN}/data"
	fowners gotify:gotify "/var/lib/${MY_PN}/data"
	fperms 700 "/var/lib/${MY_PN}/data"

	einstalldocs
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]] && ver_test ${REPLACING_VERSIONS} -lt 3.0.0; then
		echo
		ewarn "The configuration file format has changed"
		ewarn "You can convert your config.yml by issuing the following:"
		ewarn "gotify-server migrate-config config.yml > gotify-server.env"
		echo
	fi
}
