#!/bin/bash

load numbers.isFloat
load datetime.JDN2Date
load system.setLocale

function JD2DateTime() {
if [ $# -ne 1 ]; then
	return 1
fi

JD=$1
if ! $(isFloat $JD); then
	return 2
fi

JDN=$(echo "scale=0; ($JD + 0.5) / 1" | bc)
Jfrac=$(echo "($JD + 0.5) - $JDN" | bc)

Date=$(JDN2Date $JDN)
Y=$(echo "$Date" | cut -d " " -f 1)
M=$(echo "$Date" | cut -d " " -f 2)
D=$(echo "$Date" | cut -d " " -f 3)

totalSec=$(echo "scale=2; $Jfrac * 86400.0" | bc)
setLocale "C"
totalSec=$(echo "$totalSec" | awk '{printf("%.0f", $0)}')
setLocale ""

TH=$(($totalSec / 3600))
remainder=$(($totalSec % 3600))
TM=$(($remainder / 60))
TS=$(($remainder % 60))

echo "$Y $M $D $TH $TM $TS"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Julian date and time
}
