#!/bin/bash

load numbers.isInteger
load strings.isEmptyString
load strings.strlen

function charAt() {
if [ $# -ne 2 ]; then
	return 1
fi

pos="$1"
str="$2"

if $(isEmptyString "$str"); then
	return 2
fi

if ! $(isInteger "$pos"); then
	return 2
fi

if [ $pos -lt 1 -o $pos -gt $(strlen "$str") ]; then
	return 2
fi

echo "$(awk "BEGIN { FS=\"\" }; { print \$$pos }" <<< "$str")"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
