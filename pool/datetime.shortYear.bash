#!/bin/bash

load numbers.isInteger

function shortYear() {
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

y2=$(echo $y4 | sed 's/^..//')

echo "$y2"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MININUM
}
