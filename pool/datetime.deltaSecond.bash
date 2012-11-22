#!/bin/bash

load datetime.isDateTime
load datetime.DateTime2JD
load system.setLocale

function deltaSecond() {
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
deltaSec=$(bc <<< "($JD2 - $JD1) * 86400.0")

setLocale "C"
awk '{printf("%.0f\n", $0)}' <<< "$deltaSec"
setLocale ""

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Date/Time
}
