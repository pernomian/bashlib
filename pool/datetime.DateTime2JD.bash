#!/bin/bash

load datetime.isDateTime
load lists.itemAt
load datetime.Date2JDN
load system.setLocale

function DateTime2JD() {
if [ $# -ne 1 ]; then
	return 1
fi

DateTime=$1
if ! $(isDateTime "$DateTime"); then
	return 2
fi

y4=$(itemAt 1 "$DateTime")
mo=$(itemAt 2 "$DateTime")
da=$(itemAt 3 "$DateTime")
JDN=$(Date2JDN "$y4 $mo $da")

hr=$(itemAt 4 "$DateTime")
mi=$(itemAt 5 "$DateTime")
se=$(itemAt 6 "$DateTime")
JD=$(bc <<< "scale=10; $JDN + ($hr - 12) / 24.0 + $mi / 1440.0 \
             + $se / 86400.0")

setLocale "C"
echo $(awk '{printf("%.9f", $0)}' <<< "$JD")
setLocale ""

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date and/or time
}
