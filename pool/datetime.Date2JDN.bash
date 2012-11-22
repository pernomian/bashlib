#!/bin/bash

load datetime.isDate
load lists.itemAt

function Date2JDN() {
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

a=$(bc <<< "scale=0; (14 - $mo) / 12")
y=$(bc <<< "$y4 + 4800 -$a")
m=$(bc <<< "$mo + 12 * $a - 3")
JDN=$(bc <<< "scale=0; $da + (153 * $m + 2) / 5 + 365 * $y + $y / 4 \
              - $y / 100 + $y / 400 - 32045")

echo "$JDN"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}
