#!/bin/bash

load numbers.isInteger
load system.setLocale

function addLeadingZeros() {
if [ $# -ne 2 ]; then
	echo ""
	return 1
fi

len=$1
if ! $(isInteger $len); then
	return 2
fi
if [ $len -lt 1 ]; then
	return 2
fi
num=$2
if ! $(isInteger $len); then
	return 2
fi

setLocale "C"
printf "%0""$len""d" $num
setLocale ""

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Length and/or Number
}
