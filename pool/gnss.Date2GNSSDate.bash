#!/bin/bash

load datetime.isDate
load datetime.Date2JDN
load system.setLocale

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

GPSWeek=$(($dJDN / 7))
GPSDay=$(($dJDN % 7))
setLocale "C"
GPSDate=$(echo "$GPSWeek $GPSDay" | awk '{printf("%04d%1d", $1, $2)}')
setLocale ""

echo "$GPSDate"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Date
}
