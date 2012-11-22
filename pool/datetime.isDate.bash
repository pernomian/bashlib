#!/bin/bash

load lists.sizeOfList
load lists.itemAt
load numbers.isInteger
load datetime.daysInMonth

function isDate() {
MinimumYear=1970

if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")
if [ $c -ne 3 ]; then
	echo false
	return 2
fi

y4=$(itemAt 1 "$param")
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	echo false
	return 2
fi

mo=$(itemAt 2 "$param")
if ! $(isInteger $mo); then
	return 2
fi
if [ $mo -lt 1 -o $mo -gt 12 ]; then
	echo false
	return 2
fi

da=$(itemAt 3 "$param")
if ! $(isInteger $da); then
	return 2
fi
nod=$(daysInMonth $y4)
if [ $da -lt 1 -o $da -gt $(itemAt $mo "$nod") ]; then
	echo false
	return 2
fi

echo true

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}
