#/bin/sh
YARN_URL="https://registry.yarnpkg.com/"

if [[ -f "$1" ]]; then
	URLs=$(grep -o 'resolved.*' $1 | \
	sed -r 's/resolved "((.*)#.*|(.*))"/\2\3/' | \
	sed -r 's|^(https://.*/)(@.[^/]*)(.*/)(.*)(#.*)|\1\2\3\4\5 -> \2-\4|')

	IFS=$'\n'
	for i in $URLs; do
		echo $i
	done
else
	echo "Usage: $(basename $0) path/to/yarn.lock"
fi