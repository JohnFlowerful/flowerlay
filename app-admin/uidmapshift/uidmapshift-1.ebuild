# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_COMMIT="13376b1335d3c7bb79e62bd355b558f03a60ed43"

DESCRIPTION="A tool to shift uid/gid's from one range to another"
HOMEPAGE="
	https://code.launchpad.net/~serge-hallyn/+junk/nsexec
	https://github.com/hallyn/nsexec
"
SRC_URI="https://raw.githubusercontent.com/hallyn/nsexec/${MY_COMMIT}/${PN}.c"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

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
