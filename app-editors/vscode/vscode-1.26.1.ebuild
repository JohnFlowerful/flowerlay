# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils xdg-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
EGIT_REPO_URI="https://github.com/Microsoft/vscode"
EGIT_COMMIT="${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	<net-libs/nodejs-9.0
	dev-lang/python:2.7
	dev-vcs/git
	sys-apps/yarn
"

DEPEND="
	<net-libs/nodejs-9.0
	dev-vcs/git
	x11-libs/libnotify
	>=x11-libs/gtk+-2.24.8-r1:2
	gnome-base/gconf
	x11-libs/libXtst
"

PATCHES=(
	"${FILESDIR}"/product_json.patch
)


src_prepare() {
	default
	local _commit=$(git rev-parse HEAD)
	echo $_commit
	local _datestamp=$(date -u -Is | sed 's/\+00:00/Z/')
	echo $_datestamp
	sed -e "s/@COMMIT@/${_commit}/" -e "s/@DATE@/${_datestamp}/" \
		-i product.json
}

src_compile() {
	local archs=DUMMY
	case `uname -m` in
		i?86) archs=ia32 ;;
		x86_64) archs=x64 ;;
	esac
	yarn install --arch=$archs
	mem_limit="--max_old_space_size=4096"
	/usr/bin/node $mem_limit ./node_modules/.bin/gulp vscode-linux-${archs}-min || die
}

src_install() {
	default
	local archs=DUMMY
	case `uname -m` in
		i?86) archs=ia32 ;;
		x86_64) archs=x64 ;;
	esac
	local dest=/usr/share/code-oss
        insinto "${dest}"
	cd "${WORKDIR}"/VSCode-linux-"${archs}"
        doins -r *
	dosym "${dest}"/bin/code-oss /usr/bin/code-oss
	fperms +x "${dest}"/bin/code-oss
	fperms +x "${dest}"/code-oss
	domenu "${FILESDIR}"/code.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
