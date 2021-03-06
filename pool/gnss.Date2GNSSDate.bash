#!/bin/bash

load datetime.isDate
load datetime.Date2JDN

function Date2GNSSDate() {
if [ $# -ne 1 ]; then
	return 1
fi

Date="$1"
if ! $(isDate "$Date"); then
	return 2
fi

JDN1=$(Date2JDN "1980 1 6")
JDN2=$(Date2JDN "$Date")
dJDN=$(($JDN2 - $JDN1))

if [ $dJDN -lt 0 ]; then
	return 2
fi

GNSSWeek=$(($dJDN / 7))
GNSSDay=$(($dJDN % 7))

GNSSDate=$(printf "%04d%1d" $GNSSWeek $GNSSDay)

echo "$GNSSDate"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Date
}
