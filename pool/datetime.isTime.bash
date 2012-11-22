#!/bin/bash

load lists.sizeOfList
load lists.itemAt
load numbers.isInteger

function isTime() {
if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")
if [ $c -ne 3 ]; then
	echo false
	return 2
fi

hr=$(itemAt 1 "$param")
if ! $(isInteger $hr); then
	return 2
fi
if [ $hr -lt 0 -o $hr -gt 23 ]; then
	echo false
	return 2
fi

mi=$(itemAt 2 "$param")
if ! $(isInteger $mi); then
	return 2
fi
if [ $mi -lt 0 -o $mi -gt 59 ]; then
	echo false
	return 2
fi

se=$(itemAt 3 "$param")
if ! $(isInteger $se); then
	return 2
fi
if [ $se -lt 0 -o $se -gt 59 ]; then
	echo false
	return 2
fi

echo true

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid time
}
