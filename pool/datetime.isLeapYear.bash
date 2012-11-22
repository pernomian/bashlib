#!/bin/bash

load numbers.isInteger

function isLeapYear() {
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

if [ $(($y4 % 4)) -eq 0 ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MINIMUM
}
