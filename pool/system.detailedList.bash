#!/bin/bash

load system.isDirectory

function detailedList() {
if [ $# -ne 1 ]; then
	return 1
fi

dir="$1"
if ! $(isDirectory "$dir"); then
	return 2
fi

output=$(mktemp)

ls -l $dir 2> /dev/null | grep "[ld-]\([r-][w-][sx-]\)\{2\}\([r-][w-][tx-]\)\{1\}" > $output

while read line; do
	permissions=$(awk '{ print $1 }' <<< "$line")
	typechar=$(awk 'BEGIN { FS="" } { print $1 }' <<< "$permissions")
	case $typechar in
	'-')
		type='file'
		;;
	'd')
		type='folder'
		;;
	'l')
		type='link'
		;;
	*)
		type='other'
		;;
	esac
	name=$(awk '{ print $9 }' <<< "$line")
	size=$(awk '{ print $5 }' <<< "$line")
	
	if [ "$name" != "." -a \
	     "$name" != ".." ]; then
		echo "$type/$name/$size"
	fi
done < $output

rm -f $output &> /dev/null

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
