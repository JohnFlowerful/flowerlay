# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nodejs-utils.eclass
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Helpers for installing Node.js packages managed with (p)npm
# @DESCRIPTION:
# Utility functions shared between npm.eclass and pnpm.eclass

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_NODEJS_UTILS_ECLASS} ]]; then
_NODEJS_UTILS_ECLASS=1
fi

# @FUNCTION: nodejs_get_destdir
# @INTERNAL
# @USAGE: <pkg_name> <project_dir>
# @RETURN: installation path for nodejs packages gathered from either user provided variable ((P)NPM_PN) or the "name" field in package.json
nodejs_get_destdir() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	local pkg_name=${1-}
	local project_dir=${2}

	if [[ -z ${pkg_name} ]]; then
		if ! pkg_name=$(jq -er '.name | select(type == "string" and length > 0)' \
				"${project_dir}/package.json"); then
			return 1
		fi
	fi

	printf '/usr/%s/node_modules/%s' "$(get_libdir)" "${pkg_name}"
}

# @FUNCTION: nodejs_new_wrapper
# @DESCRIPTION:
# Generates a small executable script for a js entry point.
# Requires two arguments:
# $1: canonical path to the js entry point _after_ installation. Use
# (p)npm_get_destdir to get the correct path to the node_modules package
# $2: the executable name to create in /usr/bin
# @USAGE: <js_path> <exe_name>
nodejs_new_wrapper() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	local js_path="${1}"
	local exe_name="${2}"

	[[ ! -e ${D}/${js_path} ]] && die "${D}/${js_path}: no such file"

	# support both the case when NODE_WRAPPER_OPT is an array and an
	# IFS-separated string
	local -a user_args
	if [[ ${NODE_WRAPPER_OPT@a} == *a* ]]; then
		user_args=("${NODE_WRAPPER_OPT[@]}")
	else
		read -ra user_args <<< "${NODE_WRAPPER_OPT:-}"
	fi

	# quote it all properly
	local my_node=${EPREFIX}/usr/bin/node
	[[ -x ${my_node} ]] || ewarn "node not found at ${my_node}"

	local -a qargs=("$(printf '%q' "${my_node}")" "$(printf '%q' "${js_path}")")
	local arg
	for arg in "${user_args[@]}"; do
		qargs+=("$(printf '%q' "$arg")")
	done

	exeinto /usr/bin
	newexe - "${exe_name}" <<-EOF
		#!/usr/bin/env sh

		exec ${qargs[*]} "\$@"
	EOF
}

# @FUNCTION: nodejs_install_bin_wrappers
# @INTERNAL
# @DESCRIPTION:
# Uses package.json's "bin" field to create wrappers to launch standalone nodejs
# applications
nodejs_install_bin_wrappers() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	local dest_dir=${1}
	local pkg_json=${2}

	while IFS=" " read -ra bin; do
		nodejs_new_wrapper "${dest_dir}/${bin[1]}" "${bin[0]}"
	done < <(jq --raw-output '
		(.bin | type) as $typ |
		if $typ == "string" then
			.name + " " + .bin
		elif $typ == "object" then
			.bin | to_entries | map(.key + " " + .value) | join("\n")
		elif $typ == "null" then
			"\"bin\" field not found" | halt_error
		else
			"invalid type " + $typ | halt_error
		end
	' "${pkg_json}")
}

# @FUNCTION: nodejs_install_man
# @INTERNAL
# @DESCRIPTION:
# Installs the man pages defined in package.json
nodejs_install_man() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	local dest_dir=${1}
	local pkg_json=${2}

	while IFS= read -r man; do
		doman "${dest_dir}/${man}"
	done < <(jq --raw-output '
		(.man | type) as $typ |
		if $typ == "string" then
			.man
		elif $typ == "list" then
			.man | join("\n")
		elif $typ == "null" then
			empty
		else
			"invalid type " + $typ | halt_error
		end
	' "${pkg_json}")
}
