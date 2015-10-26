# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3

DESCRIPTION="A library that provides an embeddable, persistent key-value store for fast storage"
HOMEPAGE="http://rocksdb.org"
EGIT_REPO_URI="https://github.com/facebook/rocksdb.git"

LICENSE="BSD"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE="+snappy +zlib +bzip2"

DEPEND="
	dev-cpp/gflags
	snappy? ( app-arch/snappy )
	zlib? ( sys-libs/zlib )
	bzip2? ( app-arch/bzip2 )
"
RDEPEND="${DEPEND}"

src_compile() {
	emake shared_lib
}

src_install() {
	emake INSTALL_PATH="${D}/usr" install
	dodoc README.md
}