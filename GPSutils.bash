#!/bin/bash

# Required libraries
. DateTime.bash
# ---

function Date2GPS() {
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
setSystemLanguage "C"
GPSDate=$(echo "$GPSWeek $GPSDay" | awk '{printf("%04d%1d", $1, $2)}')
setSystemLanguage ""

echo "$GPSDate"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Date
}

function GPS2Date() {
if [ $# -ne 1 ]; then
	return 1
fi

GPSDate=$1
if ! $(isInteger $GPSDate); then
	return 2
fi

setSystemLanguage "C"
week=$(echo "$GPSDate" | cut -c 1-4 | awk '{printf("%d", $0)}')
setSystemLanguage ""
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
