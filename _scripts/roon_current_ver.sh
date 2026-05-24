#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

TEMPDIR="/var/tmp"

ROONSERVER_BASEURL="http://download.roonlabs.com/builds/"
ROONSERVER_FILENAME="RoonServer_linuxx64.tar.bz2"
FILE_PATH="${TEMPDIR}/${ROONSERVER_FILENAME}"

RED="" GREEN="" YELLOW="" RESET_ATTS="" ALERT_TEXT=""
if [[ -v TERM && -n "${TERM}" && "${TERM}" != "dumb" ]]; then
	RED="$(tput setaf 1)$(tput bold)"
	GREEN="$(tput setaf 2)$(tput bold)"
	YELLOW="$(tput setaf 3)$(tput bold)"
	RESET_ATTS="$(tput sgr0)"
	ALERT_TEXT="$(tput bel)"
fi
PREFIX_STRING="* "
OUTPUT_PREFIX="${GREEN}${PREFIX_STRING}${RESET_ATTS}"
QUERY_STRING="> "
QUERY_PREFIX="${GREEN}${QUERY_STRING}${RESET_ATTS}"

warning() {
	echo -e "${YELLOW}${PREFIX_STRING}${RESET_ATTS}Warning: ${1}" >&2
}

die() {
	echo -e "${RED}${PREFIX_STRING}${RESET_ATTS}Error: ${1} - exiting" >&2
	exit 1
}

test_yn_need_enter() {
	while read -rp "${QUERY_PREFIX}${1} (y/n)? ${ALERT_TEXT}" yn; do
		case "$yn" in
			[Yy]* ) return 0;;
			[Nn]* ) return 1;;
			* ) echo -e "${YELLOW}${PREFIX_STRING}${RESET_ATTS}Please answer yes or no.";;
		esac
	done
}

DOWNLOAD=true
if [[ -f "${FILE_PATH}" ]]; then
	warning "${RED}${ROONSERVER_FILENAME}${RESET_ATTS} already exists."
	if ! test_yn_need_enter "do you want to redownload it"; then
		DOWNLOAD=false
	fi
fi
if ${DOWNLOAD}; then
	rm -fv "${FILE_PATH}"
	wget -P ${TEMPDIR} "${ROONSERVER_BASEURL}${ROONSERVER_FILENAME}"
fi

echo -e "${GREEN}RoonServer version:${RESET_ATTS}"
tar xjf "${FILE_PATH}" --to-stdout RoonServer/VERSION
echo -e "\n"

if test_yn_need_enter "do you want delete ${FILE_PATH}"; then
	rm -fv "${FILE_PATH}"
fi
