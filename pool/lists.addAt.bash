#!/bin/bash

load numbers.isInteger
load lists.sizeOfList
load lists.sequence

function addAt() {
if [ $# -ne 3 ]; then
	return 1
fi

pos=$1
if ! $(isInteger $pos); then
	return 2
fi
if [ $pos -lt 1 ]; then
	return 2
fi

item="$2"
if [ -z "$item" ]; then
	return 2
fi

list="$3"
size=$(sizeOfList "$list")
if [ $pos -gt $(($size + 1)) ]; then
	return 2
fi

list=($list)
res=()
for i in $(sequence "1-$(($size + 1))"); do
	c=$(($i - 1))
	if [ $i -lt $pos ]; then
		res[$c]=${list[$c]}
	elif [ $i -eq $pos ]; then
		res[$c]="$item"
	else
		res[$c]=${list[$(($c - 1))]}
	fi
done

echo "${res[*]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Position and/or Item
}
