#!/bin/bash

load numbers.isInteger
load datetime.isLeapYear
load datetime.daysInMonth

function monthOfDOY() {
MinimumYear=1970

if [ $# -ne 2 ]; then
	return 1
fi

y4=$1
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	return 2
fi

doy=$2
if ! $(isInteger $doy); then
	return 2
fi
if $(isLeapYear $y4); then
	MaximumDOY=366
else
	MaximumDOY=365
fi
if [ $doy -lt 1 -o $doy -gt $MaximumDOY ]; then
	return 2
fi

nod=$(daysInMonth $y4)

m=1
r=$doy

for i in $nod; do
	if [ $r -gt $i ]; then
		m=$(($m + 1))
		r=$(($r - $i))
	else
		break
	fi
done

echo "$m"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}
