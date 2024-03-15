# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm.eclass
# @SUPPORTED_EAPIS: 8
# @BLURB: An eclass for installing npm based packages
# @DESCRIPTION:
# An eclass to help maintain npm based packages.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${NODE_OPTIONAL} ]]; then
	BDEPEND="
		net-libs/nodejs[npm]
		app-misc/jq
		app-portage/npm-deps
	"
fi

# @ECLASS_VARIABLE: NODE_OPTIONAL
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set to a non-null value before inherit, the nodejs part of the
# ebuild will be considered optional. You will need to set BDEPEND and call the
# required functions in your ebuild

# @ECLASS_VARIABLE: NODE_URIS
# @DEFAULT_UNSET
# @DESCRIPTION:
# A SRC_URI compatible list of URIs generated by `npm-deps uris` or otherwise.
# It is then included in the SRC_URI list.
#
# If you have defined this variable, you will need to also define a src_unpack
# function to unpack your sources independently of the ${A} variable. Don't use
# `default` in your src_unpack function!
# Example:
# @CODE
# NODE_URIS="
# 	lots
# 	and
# 	lots
# 	of
# 	uris
# "
# SRC_URI="
# 	https://github.com/$user/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
# 	${NODE_URIS}
# "
# src_unpack() {
# 	unpack "${P}.tar.gz"
# }
# @CODE

# @ECLASS_VARIABLE: NODE_WRAPPER_OPT
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing options to append to the wrapper script
# See https://nodejs.org/api/cli.html for a complete list of options
# Example:
# @CODE
# NODE_WRAPPER_OPT=("--enable-source-maps" "--use_strict")
# @CODE

# @ECLASS_VARIABLE: NPM_DEPS_DIR
# @DESCRIPTION:
# Directory where downloaded tarballs are located. This should be ${WORKDIR}/npm-deps
# when using a tarball sourced from `npm-deps download --pack`
# 
# If you have defined all nodejs source tarballs in SRC_URI, you will need to
# set this variable appropriately (likely to ${DISTDIR})
# Using this method has been discussed and is discourage upstream.
# See https://gitweb.gentoo.org/repo/gentoo.git/commit/eclass/go-module.eclass?id=62fb29
#
# The default value is ${WORKDIR}/npm-deps
export NPM_DEPS_DIR=${NPM_DEPS_DIR:="${WORKDIR}/npm-deps"}

# @ECLASS_VARIABLE: NPM_DEPS_LOCKFILE
# @DESCRIPTION:
# Path to which package-lock.json is located, relative to ${S}
# The default value is package-lock.json
: "${NPM_DEPS_LOCKFILE:="package-lock.json"}"

# @ECLASS_VARIABLE: NPM_DEPS_FIXUP_LOCKFILE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Setting to a non-null value will run `npm-deps fixup-lockfile` during the
# src_configure phase

# @ECLASS_VARIABLE: NPM_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing flags to use during all `npm` operations

# @ECLASS_VARIABLE: NPM_INSTALL_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing flags to use during `npm ci`
#
# A note about the "--omit=optional" flag:
# Some packages need optional dependencies to figure out which binary to use
# during `npm rebuild` in src_configure. This behaviour is caused by the eclass
# running `npm ci` with "--ignore-scripts". While some systems will get it right
# with the "--omit=optional" flag enabled, no-multilib profiles (and probably
# others) will not. Any superfluous packages should be cleaned up with
# `npm pack` later anyways.

# @ECLASS_VARIABLE: NPM_REBUILD_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing flags to use during `npm rebuild`

# @ECLASS_VARIABLE: NPM_BUILD_SCRIPT
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# The build script to run when `npm run` is called. A list can usually be found
# in the package.json file

# @ECLASS_VARIABLE: NPM_WORKSPACE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The workspace to build and install

# @ECLASS_VARIABLE: NPM_BUILD_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing flags to use during `npm run` (build) operations

# @ECLASS_VARIABLE: NPM_PACK_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing flags to use during `npm pack` operations

# @ECLASS_VARIABLE: NPM_PRUNE_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array variable containing flags to use during `npm prune` operations

# @ECLASS_VARIABLE: NPM_NO_PRUNE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Setting to a non-null value will disable `npm prune` in the src_install function

# Set the default npm-cache directory for this script and `npm-deps`
export NPM_CACHE_DIR="${WORKDIR}/npm-cache"

# @FUNCTION: npm_src_unpack
# @DESCRIPTION:
# Does default unpack then verifies that NPM_DEPS_DIR exists and that the
# tarballs match the integrity found in package-lock.json
npm_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${NODE_URIS} ]]; then
		die "${FUNCNAME} shouldn't be used when NODE_URIS is defined"
	fi

	default

	# verify with `npm-deps``
	if [[ -d ${NPM_DEPS_DIR} ]]; then
		if [[ -e "${S}/${NPM_DEPS_LOCKFILE}" ]]; then
			ebegin "Verifying unpacked tarballs"
			npm-deps verify-files --no-delete --lockfile "${S}/${NPM_DEPS_LOCKFILE}" || die
			eend $?
		else
			die "Directory not found ${NPM_DEPS_DIR}"
		fi
	else
		die "File not found ${S}/${NPM_DEPS_LOCKFILE}"
	fi
}

# @FUNCTION: npm_src_configure
# @DESCRIPTION:
# Configures npm to build with the distributed tarball. This relies on the
# associated script `npm-deps` to generate a cacache structure for npm to use
# during `npm ci`
npm_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	einfo "Configuring npm ..."

	export npm_config_nodedir="/usr/include/node"
	export npm_config_node_gyp="/usr/$(get_libdir)/node_modules/npm/node_modules/node-gyp/lib/node-gyp.js"

	if [[ ! -e ${NPM_DEPS_LOCKFILE} ]]; then
		die "File not found ${NPM_DEPS_LOCKFILE}"
	fi

	ebegin "Generating cacache structure"
	if [[ ! -d ${NPM_DEPS_DIR} ]]; then
		die "Directory not found ${NPM_DEPS_DIR}"
	fi
	npm-deps cacache --lockfile "${NPM_DEPS_LOCKFILE}" || die
	eend $?

	if [[ -n ${NPM_DEPS_FIXUP_LOCKFILE} ]]; then
		npm-deps fixup-lockfile --lockfile "${NPM_DEPS_LOCKFILE}"
	fi

	npm config set cache "${NPM_CACHE_DIR}"
	npm config set offline true
	npm config set progress false

	einfo "Installing dependencies ..."
	if ! npm ci --ignore-scripts "${NPM_INSTALL_FLAGS[@]}" "${NPM_FLAGS[@]}"; then
		die "npm failed to install dependencies"
	fi

	npm rebuild "${NPM_REBUILD_FLAGS[@]}" "${NPM_FLAGS[@]}"
}

# @FUNCTION: _npm_src_compile
# @DESCRIPTION:
# Runs the `npm run` build with all the provided flags
npm_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z "${NPM_BUILD_SCRIPT-}" ]]; then
		die "NPM_BUILD_SCRIPT is not set when it should be"
	fi

	if ! npm run ${NPM_WORKSPACE+--workspace=$NPM_WORKSPACE} "${NPM_BUILD_SCRIPT}" "${NPM_BUILD_FLAGS[@]}" "${NPM_FLAGS[@]}"; then
		die '`npm run` build failed'
	fi
}

# @FUNCTION: npm_src_install
# @DESCRIPTION:
# This src_install function is used to install standalone nodejs applications
# along with a basic wrapper script to launch them.
# If you're not building a standalone nodejs application (e.g. web assets), you
# will need to define your own src_install function that installs the completed
# build directory as desired.
# 
# Adapted from https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/node/build-npm-package/hooks/npm-install-hook.sh
npm_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	local -r DEST_DIR="${D}/usr/$(get_libdir)/node_modules/$(jq --raw-output '.name' package.json)"

	# `npm pack` writes to cache so temporarily override it
	while IFS= read -r file; do
		local dest="$DEST_DIR/$(dirname "$file")"
		mkdir -p "$dest"
		cp "${NPM_WORKSPACE-.}/$file" "$dest"
	done < <(jq --raw-output '.[0].files | map(.path) | join("\n")' <<< "$(npm_config_cache="$HOME/.npm" npm pack --json --dry-run --loglevel=warn --no-foreground-scripts ${NPM_WORKSPACE+--workspace=$NPM_WORKSPACE} "${NPM_BUILD_FLAGS[@]}" "${NPM_FLAGS[@]}")")

	# support both the case when NODE_WRAPPER_OPT is an array and an 
	# IFS-separated string
	if [[ "${NODE_WRAPPER_OPT+defined}" == "defined" && "$(declare -p NODE_WRAPPER_OPT)" =~ ^'declare -a NODE_WRAPPER_OPT=' ]]; then
		local -a user_args=("${NODE_WRAPPER_OPT[@]}")
	else
		local -a user_args="(${NODE_WRAPPER_OPT:-})"
	fi
	while IFS=" " read -ra bin; do
		local my_node=$(command -v node)
		newbin - ${PN} <<-EOF
			#!/usr/bin/env sh

			${my_node} "${DEST_DIR#${D}}/${bin[1]}" "${user_args[@]}" "\$@"
		EOF
	done < <(jq --raw-output '(.bin | type) as $typ | if $typ == "string" then
		.name + " " + .bin
		elif $typ == "object" then .bin | to_entries | map(.key + " " + .value) | join("\n")
		elif $typ == "null" then empty
		else "invalid type " + $typ | halt_error end' "${NPM_WORKSPACE-.}/package.json")

	while IFS= read -r man; do
		doman "$DEST_DIR/$man"
	done < <(jq --raw-output '(.man | type) as $typ | if $typ == "string" then .man
		elif $typ == "list" then .man | join("\n")
		elif $typ == "null" then empty
		else "invalid type " + $typ | halt_error end' "${NPM_WORKSPACE-.}/package.json")

	local -r NODE_MOD_PATH="$DEST_DIR/node_modules"

	# if node_modules wasn't generated with `npm pack`, prune and copy them 
	# from ${S}
	if [ ! -d "$NODE_MOD_PATH" ]; then
		if [ -z "${NPM_NO_PRUNE-}" ]; then
			if ! npm prune --omit=dev --no-save ${NPM_WORKSPACE+--workspace=$NPM_WORKSPACE} "${NPM_PRUNE_FLAGS[@]}" "${NPM_FLAGS[@]}"; then
				die '`npm prune` failed'
			fi
		fi

		find node_modules -maxdepth 1 -type d -empty -delete

		cp -r node_modules "$NODE_MOD_PATH"
	fi
}

if [[ ! ${NODE_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_unpack src_configure src_compile src_install
fi
