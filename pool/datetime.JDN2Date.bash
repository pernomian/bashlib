#!/bin/bash

load numbers.isInteger

function JDN2Date() {
if [ $# -ne 1 ]; then
	return 1
fi

JDN=$1
if ! $(isInteger $JDN); then
	return 2
fi

j=$(echo "$JDN + 32044" | bc)
g=$(echo "scale=0; $j / 146097" | bc)
dg=$(echo "$j % 146097" | bc)
c=$(echo "scale=0; ($dg / 36524 + 1) * 3 / 4" | bc)
dc=$(echo "$dg - $c * 36524" | bc)
b=$(echo "scale=0; $dc / 1461" | bc)
db=$(echo "$dc % 1461" | bc)
a=$(echo "scale=0; ($db / 365 + 1) * 3 / 4" | bc)
da=$(echo "$db -$a * 365" | bc)
y=$(echo "$g * 400 + $c * 100 + $b * 4 + $a" | bc)
m=$(echo "scale=0; ($da * 5 + 308) / 153 - 2" | bc)
d=$(echo "scale=0; $da - (($m + 4) * 153) / 5 + 122" | bc)
Y=$(echo "scale=0; $y - 4800 + ($m + 2) / 12" | bc)
M=$(echo "(($m + 2) % 12) + 1" | bc)
D=$(echo "$d + 1" | bc)

echo "$Y $M $D"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Julian date
}
