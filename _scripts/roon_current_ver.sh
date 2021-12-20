#/bin/sh
set -o errexit -o pipefail -o noclobber -o nounset

function show_help() {
	echo "usage: roon_current_ver [OPTION]"
	echo "display information about the current RoonServer release (version only by default)"
	echo
	echo "-a, --all            output both executable and stripped file information"
	echo "-d, --dir            set the working directory (/var/tmp by default)"
	echo "-e, --executables    output a list of files that have executable bit set (excludes font files)"
	echo "-s, --stripped       output a list of files that have stripped symbols"
	echo "-h, --help           show this help message"
	echo "-o, --out            print the output to files instead"
	echo
	echo "--keep-files         do not remove tarball and the extracted files"

	exit 0
}

! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
	echo "`getopt --test` failed in this environment."
	exit 1
fi

OPTS=ad:ehos
LONGOPTS=all,dir:,executables,help,keep-files,out,stripped

! PARSED=$(getopt --options=$OPTS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
	# e.g. return value is 1
	#  then getopt has complained about wrong arguments to stdout
	exit 2
fi

# read getopt's output this way to handle the quoting right:
eval set -- "$PARSED"

directory= exec= keep= out= strip=
# now enjoy the options in order and nicely split until we see --
while true; do
	case "$1" in
		-a|--all)
			exec=y strip=y
			shift;;
		-d|--dir)
			directory="$2"
			shift 2;;
		-e|--executables)
			exec=y
			shift;;
		-h|--help)
			show_help
			break;;
		--keep-files)
			keep=y
			shift;;
		-o|--output)
			out=y
			shift;;
		-s|--stripped)
			strip=y
			shift;;
		--)
			shift
			break;;
		*)
			echo "Programming error"
			exit 3;;
	esac
done


ROONSERVER_BASEURL="http://download.roonlabs.com/builds/"
ROONSERVER_FILENAME="RoonServer_linuxx64.tar.bz2"
TEMPDIR="/var/tmp"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m" # no colour

PREFIX="${GREEN}*${NC} "
ERROR_PREFIX="${RED}*${NC} "
WARN_PREFIX="${YELLOW}*${NC} "

WORKDIR=${directory}

if ! [[ ${directory} ]]; then
	echo "${PREFIX}Using ${TEMPDIR} as work directory"
	WORKDIR=${TEMPDIR}
fi

if ! [[ -d ${WORKDIR} ]]; then
	echo "${ERROR_PREFIX}$0: error: ${WORKDIR} does not exist"
	exit 1
fi

cd ${WORKDIR}

echo -e "${PREFIX}downloading ${RED}${ROONSERVER_FILENAME}"
if [[ -f "$ROONSERVER_FILENAME" ]]; then
	echo -e "${WARN_PREFIX}${RED}${ROONSERVER_FILENAME} ${NC}already exists."
	while true; do
		echo -ne "do you want to redownload ${RED}${ROONSERVER_FILENAME}${NC}? "
		read yn
		case $yn in
			[Yy]* )
				rm -f ${ROONSERVER_FILENAME}
				wget "http://download.roonlabs.com/builds/"${ROONSERVER_FILENAME}
				break;;
			[Nn]* )
				break;;
			* )
				echo "Please answer yes or no.";;
		esac
	done
else
	wget "http://download.roonlabs.com/builds/"${ROONSERVER_FILENAME}
fi

echo -e "${PREFIX}extracting ${RED}${ROONSERVER_FILENAME} ${NC}to ${WORKDIR}"
if [[ -d "${WORKDIR}/RoonServer" ]]; then
	echo -e "${WARN_PREFIX}warning: ${WORKDIR}RoonServer already exists."
	while true; do
		read -p "do you want to use existing files? " yn
		case $yn in
			[Yy]* )
				break;;
			[Nn]* )
				echo -e "${PREFIX}removing old files"
				rm -rf ${WORKDIR}/RoonServer
				echo -e "${PREFIX}extracting..."
				tar xjf ${ROONSERVER_FILENAME}
				break;;
			* )
				echo "Please answer yes or no.";;
		esac
	done
else
	tar xjf ${ROONSERVER_FILENAME}
fi

if [[ $exec ]]; then
	echo -e "${GREEN}executables:${NC}"
	executables=$(find RoonServer/ ! \( -name "*.otf" -o -name "*.ttf" \) -executable -type f | sed -r "s/RoonServer\///" | sort)
	if [[ $out ]]; then
		echo -e "${PREFIX}writing roon_executables.txt"
		printf "%s" "$executables" >| roon_executables.txt
	else
		echo "$executables"
	fi
	echo -e "\n"
fi

if [[ $strip ]]; then
	echo -e "${GREEN}stripped files:${NC}"
	stripped=$(find RoonServer/ -type f \( -name "*.so" -o -executable \) ! \( -name "*.otf" -o -name "*.ttf" -o -name "*.dll" \) -exec sh -c 'objdump --syms {} | grep -q "no symbols" && echo "{}"' \;  2>/dev/null | sed -r "s/RoonServer\///" | sort)
	if [[ $out ]]; then
		echo -e "${PREFIX}writing roon_stripped.txt"
		printf "%s" "$stripped" >| roon_stripped.txt
	else
		echo "$stripped"
	fi
	echo -e "\n"
fi

echo -e "${GREEN}RoonServer version:${NC}"
cat RoonServer/VERSION
echo -e "\n"

if ! [[ $keep ]]; then
	rm -rf ${WORKDIR}/RoonServer
	rm -i ${ROONSERVER_FILENAME}
fi