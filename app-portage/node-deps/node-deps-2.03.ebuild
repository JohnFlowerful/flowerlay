# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A helper script to ease maintaining of nodejs based Gentoo ebuilds"
HOMEPAGE="https://github.com/JohnFlowerful/node-deps"
SRC_URI="https://github.com/JohnFlowerful/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-lang/perl\
	virtual/perl-Digest-SHA
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-JSON-PP
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils
	virtual/perl-Term-ANSIColor
	dev-perl/IPC-Run3
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/YAML-PP
"

src_install() {
	dobin ${PN}
}
