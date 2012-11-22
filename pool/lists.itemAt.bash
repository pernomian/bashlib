#!/bin/bash

load numbers.isInteger
load lists.isEmptyList
load lists.sizeOfList

function itemAt() {
if [ $# -ne 2 ]; then
	return 1
fi

pos=$1
list=$2
if $(isEmptyList "$list"); then
	return 2
fi
if ! $(isInteger $pos); then
	return 2
fi
if [ $pos -lt 1 -o $pos -gt $(sizeOfList "$list") ]; then
	return 2
fi

list=($list)

echo "${list[$(($pos - 1))]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Position and/or Empty List
}
