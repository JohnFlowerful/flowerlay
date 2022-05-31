# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Service and other related files for pterodactyl-panel"
HOMEPAGE="https://pterodactyl.io/"

SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="virtual/cron"

S="${FILESDIR}"

src_install() {
	newinitd pteroq.init pteroq
	newconfd pteroq.conf pteroq

	insinto /etc/cron.d
	newins pterodactyl-panel.cron ${PN}

	insinto /usr/libexec/${PN}
	insopts -m755
	doins run-schedule
}