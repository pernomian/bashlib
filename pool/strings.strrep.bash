#!/bin/bash

load numbers.isInteger

function strrep() {
if [ $# -ne 4 ]; then
	return 1
fi

substr1="$1"
substr2="$2"
max_rep="$3"
str="$4"

if ! $(isInteger "$max_rep"); then
	return 2
fi
if [ $max_rep -lt 0 ]; then
	return 2
fi

newstr="$str"

if [ $max_rep -eq 0 ]; then
	newstr="$(sed "s/$substr1/$substr2/g" <<< "$newstr")"
else
	nrep=0
	while [ $nrep -lt $max_rep ]; do
		newstr="$(sed "s/$substr1/$substr2/1" <<< "$newstr")"
		nrep=$(($nrep + 1))
	done
fi

echo "$newstr"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
