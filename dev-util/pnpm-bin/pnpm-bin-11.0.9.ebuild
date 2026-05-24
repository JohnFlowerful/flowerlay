# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"

DESCRIPTION="Fast, disk space efficient package manager, alternative to npm and yarn"
HOMEPAGE="https://pnpm.io"
SRC_URI="
	https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-x64.tar.gz
		-> ${P}.tar.gz
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="!net-libs/nodejs[corepack]"

QA_PREBUILT="opt/pnpm/pnpm"

src_install() {
	# dist/ is expected and hardcoded:
	# https://github.com/pnpm/pnpm/blob/v11.0.9/pnpm/pnpm.cjs#L18
	local ins_dir="/opt/${MY_PN}"
	exeinto "${ins_dir}"
	doexe pnpm

	insinto "${ins_dir}"
	doins -r "dist/"

	newbin - "${MY_PN}" <<-EOF
			#!/bin/sh

			exec /opt/pnpm/pnpm "\$@"
		EOF
}
