#!/bin/bash

function lowerCase() {
if [ $# -ne 1 ]; then
	return 1
fi

str="$1"

newstr=$(tr [:upper:] [:lower:] <<< "$str")

echo "$newstr"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
