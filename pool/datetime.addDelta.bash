#!/bin/bash

load datetime.DateTime2JD
load datetime.isDateTime
load datetime.isDelta
load datetime.JD2DateTime
load lists.itemAt
load numbers.abs

function addDelta() {
if [ $# -ne 2 ]; then
	return 1
fi

DateTime="$1"
Delta="$2"
if ! $(isDateTime "$DateTime") || ! $(isDelta "$Delta"); then
	return 2
fi

JD1=$(DateTime2JD "$DateTime")

dDay=$(itemAt 1 "$Delta")
dHour=$(itemAt 2 "$Delta")
dMin=$(itemAt 3 "$Delta")
dSec=$(itemAt 4 "$Delta")

negativeDelta=false
if [ $dDay -lt 0 ]; then
	negativeDelta=true
	dDay=$(abs "$dDay")
fi
if [ $dHour -lt 0 ]; then
	negativeDelta=true
	dHour=$(abs "$dHour")
fi
if [ $dMin -lt 0 ]; then
	negativeDelta=true
	dMin=$(abs "$dMin")
fi
if [ $dSec -lt 0 ]; then
	negativeDelta=true
	dSec=$(abs "$dSec")
fi

dJD=$(bc -l <<< "$dDay + ($dHour / 24.0) + ($dMin / 1440.0) + ($dSec / 86400.0)")
if $negativeDelta; then
	dJD=-$dJD
fi

JD2=$(bc <<< "$JD1 + $dJD")

DateTime2=$(JD2DateTime $JD2)

echo "$DateTime2"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
