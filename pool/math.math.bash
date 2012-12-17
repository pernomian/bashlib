#!/bin/bash

function math() {
if [ $# -ne 1 ]; then
	return 1
fi

arg="$1"

ans="$(bc -l 2> /dev/null <<< "scale=20; $arg")"
if [ -z "$ans" ]; then
	return 2
fi

awk '{ printf("%.16f\n", $1) }' <<< "$ans"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
