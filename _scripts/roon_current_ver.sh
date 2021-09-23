#/bin/sh
ROONSERVER_FILENAME="RoonServer_linuxx64.tar.bz2"
TEMPDIR="/var/tmp"

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # no colour

cd ${TEMPDIR}
if [ -f "$ROONSERVER_FILENAME" ]; then
    echo -e "download skipped: ${RED}${ROONSERVER_FILENAME} ${NC}already exists."
else
    wget "http://download.roonlabs.com/builds/"${ROONSERVER_FILENAME}
fi
echo -e "extracting ${RED}${ROONSERVER_FILENAME} ${NC}to ${TEMPDIR}\n"
tar xjf ${ROONSERVER_FILENAME}
echo -e "${GREEN}executables:${NC}"
find RoonServer/ ! \( -name "*.otf" -o -name "*.ttf" \) -executable -type f | sed -r "s/RoonServer\///"
echo -e "\n"
echo -e "${GREEN}stripped files:${NC}"
find RoonServer/ -type f \( -name "*.so" -o -executable \) ! \( -name "*.otf" -o -name "*.ttf" -o -name "*.dll" \) -exec sh -c 'objdump --syms {} | grep -q "no symbols" && echo "{}"' \;  2>/dev/null | sed -r "s/RoonServer\///"
echo -e "\n"
echo -e "${GREEN}RoonServer version:${NC}"
cat RoonServer/VERSION
echo -e "\n"
rm -rf ${TEMPDIR}/RoonServer
rm -i ${ROONSERVER_FILENAME}