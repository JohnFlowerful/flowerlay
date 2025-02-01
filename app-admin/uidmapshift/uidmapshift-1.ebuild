# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A tool to shift uid/gid's from one range to another"
HOMEPAGE="https://code.launchpad.net/~serge-hallyn/+junk/nsexec"
SRC_URI="http://bazaar.launchpad.net/~serge-hallyn/+junk/nsexec/download/head:/${PN}.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}"

src_compile() {
	local cmd=(
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}
		"${DISTDIR}/${PN}".c -o "${PN}"
	)
	echo "${cmd[@]}"
	"${cmd[@]}" || die
}

src_install() {
	dobin "${PN}"
}
