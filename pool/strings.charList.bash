#!/bin/bash

load strings.strlen

function charList() {
if [ $# -ne 1 ]; then
	return 1
fi

str="$1"

len=$(strlen "$str")
if [ $len -eq 0 ]; then
	echo ""
else
	for i in $(seq 1 1 $len); do
		chars[$(($i - 1))]=$(awk "BEGIN { FS=\"\" }; { print $\"$i\" }" <<< "$str")
	done

	echo "${chars[*]}"
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Empty string
}
