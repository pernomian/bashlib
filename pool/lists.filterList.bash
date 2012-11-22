#!/bin/bash

load lists.isEmptyList

function filterList() {
if [ $# -ne 2 ]; then
	return 1
fi

criteria=$1
if [ -z "$criteria" ]; then
	return 2
fi

inlist=$2
if $(isEmptyList "$inlist"); then
	return 2
fi

outlist=""
for i in $inlist; do
	if [ -n "$(echo "$i" | grep "$criteria")" ]; then
		if [ -z "$outlist" ]; then
			outlist="$i"
		else
			outlist="$outlist $i"
		fi
	fi
done

echo "$outlist"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Empty Criteria and/or List
}
