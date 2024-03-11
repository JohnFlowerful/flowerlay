# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A helper script for npm based Gentoo ebuilds"
HOMEPAGE="https://github.com/JohnFlowerful/npm-deps"
SRC_URI="https://github.com/JohnFlowerful/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-lang/perl
	virtual/perl-Getopt-Long
	virtual/perl-JSON-PP
	virtual/perl-MIME-Base64
	dev-perl/IPC-Run3
	dev-perl/libwww-perl
	dev-perl/URI
"

src_install() {
	newbin ${PN}.pl ${PN}
}
