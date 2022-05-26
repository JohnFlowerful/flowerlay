#/bin/sh

# why not `yarn install' and use node_modules dir? size?
# does `yarn install --offline' check file checksums?
YARN_DIR="yarn_distfiles"

if [[ -f "$1" ]]; then
	# assume url is https
	URLs=$(grep -o 'resolved.*' $1 | \
		sed -r 's/resolved "(.*)"/\1/' | \
		sed -r 's|^(https://.*/)(@.[^/]*)(.*/)(.*)(#.*)|\1\2\3\4\5 -> \2-\4|')

	# TODO: maybe add basic filename comparison
	if [[ -d $YARN_DIR ]]; then
		echo "Error: Directory '$YARN_DIR' already exists. Exiting."
		exit 1
	fi
	mkdir $YARN_DIR

	pushd $YARN_DIR > /dev/null
	IFS=$'\n'
	get_errors=()
	for i in $URLs; do
		my_url=$(echo $i | cut -d " " -f1)

		my_checksum=false
		if [[ "$my_url" == *"#"* ]]; then # has sha1 checksum
			my_checksum=$(cut -d "#" -f2 <<< $my_url)
		fi

		if [[ "$my_url" == *".tgz"* ]]; then
			if [[ $(cut -d " " -f2 <<< $i) == "->" ]]; then
				my_filename=$(cut -d " " -f3 <<< $i)
				wget -q $my_url -O $my_filename
			else
				my_filename=$(sed -r 's|.*/(.*.tgz).*|\1|' <<< $my_url)
				wget -q $my_url
			fi
			if [[ $? -ne 0 ]]; then
				get_errors+=($my_url)
			fi
			if [[ ! "$my_checksum" = false ]]; then
				# sha1sum will output an error if checksum mismatch, even when --quiet
				sha1sum --quiet --check <<< "$my_checksum $my_filename"
			fi
		else
			echo "Error: unexpected filename suffix in '$i'"
			exit 1
		fi
	done

	if [[ ${#get_errors[@]} -ne 0 ]]; then
		echo "Warning: these URLs failed to download:"
		for i in "${get_errors[@]}"; do
			echo $i
		done
	fi
	popd > /dev/null
else
	echo "Usage: $(basename $0) path/to/yarn.lock"
fi