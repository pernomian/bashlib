#!/bin/bash

load lists.isEmptyList

function hasItem() {
if [ $# -ne 2 ]; then
	return 1
fi

item="$1"
if [ -z "$item" ]; then
	return 2
fi

list="$2"
if $(isEmptyList "$list"); then
	return 2
fi

if [ -n "$(echo "$list" | grep "$item")" ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Empty Item and/or List
}
