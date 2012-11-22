#!/bin/bash

function isNumber() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1

gexpr='^[-+]\?[0-9]*\.\?[0-9]*\([Ee][-+]\?[0-9]\+\)\?$'
res=$(echo $param | grep -x "$gexpr")
# NOTE: grep -x forces a line match (POSIX compliant)

# Test if $res return a non-zero string (number is valid)
if [ -n "$res" ]; then
	# Check if resulting number doesn't begin with [Ee]
	sciweird=$(echo "$res" | grep '^[-+]\?\.\?[Ee]\|[Ee]$')
	if [ -z "$sciweird" ]; then
		echo true
	else
		echo false
	fi
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
