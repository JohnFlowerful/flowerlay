#/bin/sh
YARN_URL="https://registry.yarnpkg.com/"

if [[ -f "$1" ]]; then
	URLs=$(grep -o 'resolved.*' $1 | sed 's/resolved "\(.*\)#.*/\1/')
	yarn_URLs=$(grep -o '^'$YARN_URL'.*' <<< $URLs | sed -r 's|'$YARN_URL'(@.[^/]*)(.*/)(.*$)|'$YARN_URL'\1\2\3 -> \1-\3|')
	non_yarn_URLs=$(grep -v -e '^'$YARN_URL'.*' <<< $URLs)

	IFS=$'\n'
	for i in $yarn_URLs; do
		echo $i
	done

	echo
	echo "These packages require manual attention:"
	for i in $non_yarn_URLs; do
		echo $i
	done
else
	echo "Usage: $(basename $0) path/to/yarn.lock"
fi