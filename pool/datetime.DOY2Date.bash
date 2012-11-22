#!/bin/bash

load datetime.isLeapYear
load datetime.daysInMonth
load lists.sequence
load lists.itemAt

function DOY2Date() {
MinimumYear=1970

if [ $# -ne 2 ]; then
	return 1
fi

y4=$1
if [ $y4 -lt $MinimumYear ]; then
	return 2
fi

doy=$(echo "$2" | sed 's/^0*//')
if $(isLeapYear $y4); then
	MaximumDOY=366
else
	MaximumDOY=365
fi
if [ $doy -lt 1 -o $doy -gt $MaximumDOY ]; then
	return 2
fi

mo=1
da=0

r=$doy
nod=$(daysInMonth $y4)
for cm in $(sequence "1-12"); do
	dicm=$(itemAt $cm "$nod")
	if [ $r -gt $dicm ]; then
		mo=$(($mo + 1))
		r=$(($r - $dicm))
	else
		da=$r
		break
	fi
done

echo "$y4 $mo $da"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}
