#!/bin/bash

load numbers.isInteger

function Minutes2Time() {
if [ $# -ne 1 ]; then
	return 1
fi

Minutes=$1
if ! $(isInteger $Minutes); then
	return 2
fi

if [ $Minutes -lt 0 -o $Minutes -gt 1439 ]; then
	return 3
fi

hr=$(($Minutes / 60))
mi=$(($Minutes % 60))

Time="$hr $mi 0"

echo "$Time"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - DayMin is not integer
# 3 - DayMin is out of range
}
