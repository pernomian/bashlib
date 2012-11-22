#!/bin/bash

load numbers.isInteger
load datetime.isDate
load datetime.Date2JDN
load datetime.JDN2Date

function incrementDay() {
if [ $# -ne 2 ]; then
	return 1
fi

inc=$1
if ! $(isInteger $inc); then
	return 2
fi
if [ $inc -lt -32768 -o $inc -gt 32768 ]; then
	return 3
fi

Date="$2"
if ! $(isDate "$Date"); then
	return 4
fi

cJDN=$(Date2JDN "$Date")

nJDN=$(($cJDN + $inc))

nDate=$(JDN2Date $nJDN)

echo "$nDate"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Increment not integer
# 3 - Increment out of allowed range
# 4 - Invalid date
}
