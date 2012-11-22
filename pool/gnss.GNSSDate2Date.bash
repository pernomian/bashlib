#!/bin/bash

load numbers.isInteger
load system.setLocale
load datetime.Date2JDN
load datetime.JDN2Date

function GNSSDate2Date() {
if [ $# -ne 1 ]; then
	return 1
fi

GPSDate=$1
if ! $(isInteger $GPSDate); then
	return 2
fi

setLocale "C"
week=$(echo "$GPSDate" | cut -c 1-4 | awk '{printf("%d", $0)}')
setLocale ""
day=$(echo "$GPSDate" | cut -c 5)
GPSdays=$(($week * 7 + $day))

JDN1=$(Date2JDN "1980 1 6")
JDN2=$(($JDN1 + $GPSdays))

Date=$(JDN2Date $JDN2)

echo "$Date"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid GPS Date
}
