#!/bin/bash

load numbers.isInteger
load datetime.isTime
load lists.itemAt
load datetime.Time2Minutes
load datetime.Minutes2Time

function incrementMinute() {
if [ $# -ne 2 ]; then
	return 1
fi

inc=$1
if ! $(isInteger $inc); then
	return 2
fi
if [ $inc -lt -1439 -o $inc -gt 1439 ]; then
	return 3
fi

cTime="$2"
if ! $(isTime "$cTime"); then
	return 4
fi

cse=$(itemAt 3 "$cTime")

cdami=$(Time2Minutes "$cTime")

ndami=$(($cdami + $inc))
if [ $ndami -lt 0 ]; then
	ndami=$((1440 + $ndami))
fi
if [ $ndami -gt 1439 ]; then
	ndami=$(($ndami - 1440))
fi

nTime=$(Minutes2Time $ndami)
nhr=$(itemAt 1 "$nTime")
nmi=$(itemAt 2 "$nTime")

echo "$nhr $nmi $cse"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Increment is not integer
# 3 - Increment is out of range
# 4 - Invalid time
}
