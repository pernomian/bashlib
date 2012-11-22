#!/bin/bash

load datetime.isDate
load lists.itemAt
load datetime.daysInMonth
load lists.sequence

function Date2DOY() {
if [ $# -ne 1 ]; then
	return 1
fi

Date="$1"
if ! $(isDate "$Date"); then
	return 2
fi

y4=$(itemAt 1 "$Date")
mo=$(itemAt 2 "$Date")
da=$(itemAt 3 "$Date")

doy=0
nod=$(daysInMonth $y4)
for m in $(sequence "1-$(($mo - 1))"); do
	doy=$(($doy + $(itemAt $m "$nod")))
done
doy=$(($doy + $da))

echo "$doy"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}
