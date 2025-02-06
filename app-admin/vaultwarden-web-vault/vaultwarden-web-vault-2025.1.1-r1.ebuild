# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

MY_PV=${PV%c}

# vaultwarden patch
#MY_PATCHV=$(ver_cut 1-2).0
MY_PATCHV="${MY_PV}"

BW_WEB_BUILDS="${WORKDIR}/bw_web_builds-${PV}"
BW_RESOURCES="${BW_WEB_BUILDS}/resources"

DESCRIPTION="Web vault builds for vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

SRC_URI="
	https://github.com/bitwarden/clients/archive/web-v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz
	https://github.com/dani-garcia/bw_web_builds/archive/v${PV}.tar.gz -> ${P}-resources.tar.gz
	https://dandelion.ilypetals.net/dist/nodejs/${PN}-${MY_PV}-npm-deps.tar.gz
"

S="${WORKDIR}/clients-web-v${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=">=net-libs/nodejs-20"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

NPM_FLAGS=("--legacy-peer-deps")
NPM_BUILD_FLAGS=("--workspace" "apps/web")
NPM_BUILD_SCRIPT="build:oss:selfhost:prod"
export ELECTRON_SKIP_BINARY_DOWNLOAD=1

PATCHES=(
	# apply vaultwarden patches
	# see https://github.com/dani-garcia/bw_web_builds/blob/master/scripts/apply_patches.sh
	"${BW_WEB_BUILDS}/patches/v${MY_PATCHV}.patch"
)

src_prepare() {
	# copy vaultwarden assets
	cp -fr "${BW_RESOURCES}/src/"* apps/web/src/ || die

	# replace embedded logos
	replace_embedded_svg_icon \
		${BW_RESOURCES}/vaultwarden-admin-console-logo.svg \
		apps/web/src/app/admin-console/icons/admin-console-logo.ts || die
	replace_embedded_svg_icon \
		${BW_RESOURCES}/vaultwarden-password-manager-logo.svg \
		apps/web/src/app/layouts/password-manager-logo.ts || die
	replace_embedded_svg_icon \
		${BW_RESOURCES}/src/images/logo.svg \
		./libs/auth/src/angular/icons/bitwarden-logo.icon.ts
	replace_embedded_svg_icon \
		${BW_RESOURCES}/vaultwarden-icon.svg \
		./libs/auth/src/angular/icons/bitwarden-shield.icon.ts

	# remove non-free code. it wasn't used as per
	# https://github.com/dani-garcia/bw_web_builds/issues/162#issuecomment-2123417759
	rm -rf ./bitwarden_license/ || die

	if [[ -d "./apps/web/src/app/tools/access-intelligence/" ]]; then
		rm -rf ./apps/web/src/app/tools/access-intelligence/
	fi

	default
}

src_install() {
	insinto "/usr/share/${PN}/htdocs"
	doins -r apps/web/build/*

	einstalldocs
}

# https://github.com/dani-garcia/bw_web_builds/blob/master/scripts/apply_patches.sh#L4-L14
replace_embedded_svg_icon() {
if [ ! -f $1 ]; then echo "$1 does not exist"; exit -1; fi
if [ ! -f $2 ]; then echo "$2 does not exist"; exit -1; fi

echo "'$1' -> '$2'"

first='`$'
last='^`'
sed -i "/$first/,/$last/{ /$first/{p; r $1
}; /$last/p; d }" $2
}
