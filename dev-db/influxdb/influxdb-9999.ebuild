# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user golang-build golang-vcs

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com/"
EGO_PN=github.com/influxdata/influxdb

MY_P=${PN}-${PV}

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-lang/go-bootstrap
	>=dev-lang/go-1.5
	dev-libs/leveldb
	dev-db/rocksdb
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src/github.com/influxdata/${PN}"

src_compile() {
	export GOPATH=${WORKDIR}/${MY_P}
	go get -u -f -t ./...
	go build -tags rocksdb ./... || die "compilation failed"
}

src_test() {
	./${PN} -v || die "test failed"
}

pkg_preinst() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

pkg_postinst()
{
	chown influxdb:influxdb -R /var/lib/influxdb
	chown influxdb:influxdb -R /var/log/influxdb
}

src_install() {
	dobin ${WORKDIR}/${MY_P}/bin/{${PN%?},${PN%??}}
	insinto /usr/lib/systemd/system/
	newins ${FILESDIR}/${PN}.service ${PN}.service
	dodoc LICENSE
	dodoc etc/config.sample.toml
	cp -i etc/config.sample.toml etc/${PN}.conf
	sed -i 's/reporting-disabled = false/reporting-disabled = true/g' etc/${PN}.conf
	sed -i 's/\/var\/opt\/influxdb\/meta/\/var\/lib\/influxdb\/meta/g' etc/${PN}.conf
	sed -i 's/\/var\/opt\/influxdb\/data/\/var\/lib\/influxdb\/data/g' etc/${PN}.conf
	sed -i 's/\/var\/opt\/influxdb\/wal/\/var\/lib\/influxdb\/wal/g' etc/${PN}.conf
	sed -i 's/\/var\/opt\/influxdb\/hh/\/var\/lib\/influxdb\/hh/g' etc/${PN}.conf
	insinto /etc
	doins etc/${PN}.conf
	insinto /usr/share/${PN}
	dodir /var/lib/influxdb/{data,hh,meta,wal}
	dodir /var/log/influxdb
}
