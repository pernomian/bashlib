#!/bin/bash

load datetime.Date2JDN
load datetime.JDN2Date
load gnss.isGNSSDate
load numbers.normalizeInteger
load strings.substring

function GNSSDate2Date() {
if [ $# -ne 1 ]; then
	return 1
fi

GNSSDate="$1"
if ! $(isGNSSDate $GNSSDate); then
	return 2
fi

week=$(normalizeInteger $(substring 1 4 "$GNSSDate"))

day=$(substring 5 5 "$GNSSDate")
GNSSdays=$(($week * 7 + $day))

JDN1=$(Date2JDN "1980 1 6")
JDN2=$(($JDN1 + $GNSSdays))

Date=$(JDN2Date $JDN2)

echo "$Date"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid GPS Date
}
