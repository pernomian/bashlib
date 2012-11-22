#!/bin/bash

load numbers.isInteger

function normalizeInteger() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isInteger $param); then
	return 2
fi

signal=$(echo "$param" | grep "^[+-]" | cut -c 1)

if [ -z "$signal" ]; then
	number=$param
else
	number=$(echo "$param" | sed "s/^$signal//")
fi

# Remove number's leading zeros
res=$(echo "$number" | sed 's/^0*//')
#    If the number is just a sequency of zeros, the last sed will remove
# all of them.
#    If it is also empty, this check solves that by setting res=0 
if [ -z "$res" ]; then
	res=0
fi

#    Place again the "-" before negative numbers. The "+" is supressed
# in positive ones. 
if [ "$signal" == "-" ]; then
	#    If the number is zero but is preceded by "-", the signal is
	# supressed in this check
	if [ $res -ne 0 ]; then 
		res=-$res
	fi
fi

echo $res
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not integer
}
