#!/bin/bash

function isEmptyList() {
if [ $# -ne 1 ]; then
	return 1
fi

list=($1)

if [ ${#list[*]} -eq 0 ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
