#!/bin/bash

load datetime.isDate
load datetime.Date2JDN

function deltaDay() {
if [ $# -ne 2 ]; then
	return 1
fi

Date1="$1"
if ! $(isDate "$Date1"); then
	return 2
fi

Date2="$2"
if ! $(isDate "$Date2"); then
	return 2
fi

JDN1=$(Date2JDN "$Date1")
JDN2=$(Date2JDN "$Date2")
deltaJDN=$(($JDN2 - $JDN1))

echo "$deltaJDN"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date(s)
}
