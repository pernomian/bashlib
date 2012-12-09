#!/bin/bash

load system.isDirectory

function list() {
if [ $# -ne 1 ]; then
	return 1
fi

dir="$1"
if ! $(isDirectory "$dir"); then
	return 2
fi

list="$(ls $dir 2> /dev/null)"

echo "$list"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
