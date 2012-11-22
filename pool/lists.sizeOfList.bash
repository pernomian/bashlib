#!/bin/bash

function sizeOfList() {
if [ $# -ne 1 ]; then
	return 1
fi

list=($1)

echo ${#list[*]}

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
