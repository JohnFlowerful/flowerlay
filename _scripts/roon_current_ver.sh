#/bin/sh
ROONSERVER_FILENAME="RoonServer_linuxx64.tar.bz2"

cd /var/tmp
wget "http://download.roonlabs.com/builds/"${ROONSERVER_FILENAME} 
tar xjf ${ROONSERVER_FILENAME}
cat RoonServer/VERSION
rm -rf /var/tmp/RoonServer
rm -f ${ROONSERVER_FILENAME}