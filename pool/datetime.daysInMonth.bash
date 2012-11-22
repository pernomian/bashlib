#!/bin/bash

load numbers.isInteger
load datetime.isLeapYear

function daysInMonth() {
MinimumYear=1970

if [ $# -ne 1 ]; then
	return 1
fi

y4=$1
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	return 3
fi

dim=(31 28 31 30 31 30 31 31 30 31 30 31)
if $(isLeapYear $y4); then
	dim[1]=29
fi

echo "${dim[*]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MINIMUM
}
