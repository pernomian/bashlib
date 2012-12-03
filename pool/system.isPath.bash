#!/bin/bash

function isPath() {
if [ $# -ne 1 ]; then
	return 1
fi

if [ ${#1} -eq 0 ]; then
	echo false
elif [ "$(awk 'BEGIN {FS=""} {print $1}' <<< "$1")" != "/" ]; then
	echo false
else
	echo true
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
