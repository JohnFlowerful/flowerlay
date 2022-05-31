# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Pterodactyl® is a free, open-source game server management panel built with PHP, React, and Go."
HOMEPAGE="https://pterodactyl.io/"

SRC_URI="
	https://github.com/pterodactyl/panel/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dandelion.ilypetals.net/dist/nodejs/${P}-yarn_distfiles.tar.xz
	https://dandelion.ilypetals.net/dist/php/${P}-composer_cache.tar.xz
"

LICENSE="MIT"
KEYWORDS="amd64"
IUSE=""

BDEPEND="
	sys-apps/yarn
	=net-libs/nodejs-14*
"
DEPEND="
	dev-db/redis
	>=dev-lang/php-7.4:*[bcmath,cli,curl,fpm,gd,mysql,pdo,sodium,ssl,tokenizer,unicode,xml,xmlreader,xmlwriter,zip]
	dev-php/composer
	virtual/mysql
"
RDEPEND="
	${DEPEND}
	www-apps/pterodactyl-panel-common
"

RESTRICT="mirror"

# if the desired webserver is not apache, install beforehand. setting 'vhost_server'
# in /etc/vhosts/webapp-config is not sufficient
need_httpd_cgi

S="${WORKDIR}/panel-${PV}"

src_prepare() {
	# cleanup
	find "${S}" -type f -name '.git*' -delete
	rm -rf .github

	default
}

src_configure() {
	yarn config set disable-self-update-check true || die
	yarn config set nodedir /usr/include/node || die
	yarn config set yarn-offline-mirror "${WORKDIR}/yarn_distfiles" || die
	yarn install --frozen-lockfile --offline --no-progress || die
}

src_compile() {
	einfo "building web assets"
	yarn run build:production || die
	rm -rf node_modules

	einfo "installing php dependencies"
	composer config cache-dir "${WORKDIR}/composer_cache"
	composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist || die
}

src_install() {
	cp .env.example .env

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/.env
	webapp_serverowned -R "${MY_HTDOCSDIR}"/config
	webapp_serverowned -R "${MY_HTDOCSDIR}"/storage
	webapp_serverowned -R "${MY_HTDOCSDIR}"/bootstrap/cache
	webapp_configfile "${MY_HTDOCSDIR}"/.env
	webapp_configfile "${MY_HTDOCSDIR}"/config
	webapp_configfile "${MY_HTDOCSDIR}"/storage

	webapp_src_install
}