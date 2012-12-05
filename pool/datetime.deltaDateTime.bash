#!/bin/bash

load datetime.DateTime2JD
load datetime.isDateTime
load datetime.Minutes2Time
load lists.itemAt

function deltaDateTime() {
if [ $# -ne 2 ]; then
	return 1
fi

DateTime1="$1"
if ! $(isDateTime "$DateTime1"); then
	return 2
fi

DateTime2="$2"
if ! $(isDateTime "$DateTime2"); then
	return 2
fi

JD1=$(DateTime2JD "$DateTime1")
JD2=$(DateTime2JD "$DateTime2")

deltaJD=$(bc -l <<< "$JD2 - $JD1")
if [ $(bc <<< "$deltaJD < 0") -eq 1 ]; then
	negative=true
else
	negative=false
fi

if $negative; then
	deltaJD=$(bc -l <<< "scale=20; $deltaJD * -1.0")
fi

deltaDay=$(bc <<< "scale=0; $deltaJD / 1")

Seconds=$(bc -l <<< "scale=10; ($deltaJD - $deltaDay) * 86400.0")
Seconds=$(awk '{printf("%.0f", $0)}' <<< "$Seconds") #Round
Minutes=$(($Seconds / 60))
deltaSec=$(($Seconds % 60))

Time=$(Minutes2Time "$Minutes")
deltaHour=$(itemAt 1 "$Time")
deltaMin=$(itemAt 2 "$Time")

if $negative; then
	if [ $deltaDay -ne 0 ]; then
		delta="-$deltaDay $deltaHour $deltaMin $deltaSec"
	else
		if [ $deltaHour -ne 0 ]; then
			delta="$deltaDay -$deltaHour $deltaMin $deltaSec"
		else
			if [ $deltaMin -ne 0 ]; then
				delta="$deltaDay $deltaHour -$deltaMin $deltaSec"
			else
				delta="$deltaDay $deltaHour $deltaMin -$deltaSec"
			fi
		fi
	fi
else
	delta="$deltaDay $deltaHour $deltaMin $deltaSec"
fi

echo "$delta"


return 0
# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date(s)
}
