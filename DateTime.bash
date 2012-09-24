#!/bin/bash

# Required Libraries
. Lists.bash
. Numbers.bash
. Output.bash
# ---

# Initialization
MinimumYear=1970
# ---

function Date2DOY() {
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

doy=0
nod=$(daysInMonth $y4)
for m in $(seq 1 1 $(($mo - 1))); do
	doy=$(($doy + $(itemAt $m "$nod")))
done
doy=$(($doy + $da))

echo "$doy"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

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

a=$(echo "scale=0; (14 - $mo) / 12" | bc)
y=$(echo "$y4 + 4800 -$a" | bc)
m=$(echo "$mo + 12 * $a - 3" | bc)
JDN=$(echo "scale=0; $da + (153 * $m + 2) / 5 + 365 * $y + $y / 4 \
    - $y / 100 + $y / 400 - 32045" | bc)

echo "$JDN"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

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
JD=$(echo "scale=10; $JDN + ($hr - 12) / 24.0 + $mi / 1440.0 \
   + $se / 86400.0" | bc)

setSystemLanguage "C"
echo $(echo "$JD" | awk '{printf("%.9f", $0)}')
setSystemLanguage ""

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date and/or time
}

function daysInMonth() {
if [ $# -ne 1 ]; then
	return 1
fi

y4=$1
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	return 3
fi

dim=(31 28 31 30 31 30 31 31 30 31 30 31)
if $(isLeapYear $y4); then
	dim[1]=29
fi

echo "${dim[*]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MINIMUM
}

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
deltaSec=$(echo "($JD2 - $JD1) * 86400.0" | bc)

setSystemLanguage "C"
echo $(echo "$deltaSec" | awk '{printf("%.0f", $0)}')
setSystemLanguage ""

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Date/Time
}

function DOY2Date() {
if [ $# -ne 2 ]; then
	return 1
fi

y4=$1
if [ $y4 -lt $MinimumYear ]; then
	return 2
fi

doy=$(echo "$2" | sed 's/^0*//')
if $(isLeapYear $y4); then
	MaximumDOY=366
else
	MaximumDOY=365
fi
if [ $doy -lt 1 -o $doy -gt $MaximumDOY ]; then
	return 2
fi

mo=1
da=0

r=$doy
nod=$(daysInMonth $y4)
for cm in $(seq 1 1 12); do
	dicm=$(itemAt $cm "$nod")
	if [ $r -gt $dicm ]; then
		mo=$(($mo + 1))
		r=$(($r - $dicm))
	else
		da=$r
		break
	fi
done

echo "$y4 $mo $da"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

function incrementDay() {
if [ $# -ne 2 ]; then
	return 1
fi

inc=$1
if ! $(isInteger $inc); then
	return 2
fi
if [ $inc -lt -32768 -o $inc -gt 32768 ]; then
	return 3
fi

Date="$2"
if ! $(isDate "$Date"); then
	return 4
fi

cJDN=$(Date2JDN "$Date")

nJDN=$(($cJDN + $inc))

nDate=$(JDN2Date $nJDN)

echo "$nDate"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Increment not integer
# 3 - Increment out of allowed range
# 4 - Invalid date
}

function incrementMinute() {
if [ $# -ne 2 ]; then
	return 1
fi

inc=$1
if ! $(isInteger $inc); then
	return 2
fi
if [ $inc -lt -1439 -o $inc -gt 1439 ]; then
	return 3
fi

cTime="$2"
if ! $(isTime "$cTime"); then
	return 4
fi

cse=$(itemAt 3 "$cTime")

cdami=$(Time2Minutes "$cTime")

ndami=$(($cdami + $inc))
if [ $ndami -lt 0 ]; then
	ndami=$((1440 + $ndami))
fi
if [ $ndami -gt 1439 ]; then
	ndami=$(($ndami - 1440))
fi

nTime=$(Minutes2Time $ndami)
nhr=$(itemAt 1 "$nTime")
nmi=$(itemAt 2 "$nTime")

echo "$nhr $nmi $cse"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Increment is not integer
# 3 - Increment is out of range
# 4 - Invalid time
}

function isLeapYear() {
if [ $# -ne 1 ]; then
	return 1
fi

y4=$1
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	return 3
fi

if [ $(($y4 % 4)) -eq 0 ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MINIMUM
}

function isDate() {
if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")
if [ $c -ne 3 ]; then
	echo false
	return 2
fi

y4=$(itemAt 1 "$param")
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	echo false
	return 2
fi

mo=$(itemAt 2 "$param")
if ! $(isInteger $mo); then
	return 2
fi
if [ $mo -lt 1 -o $mo -gt 12 ]; then
	echo false
	return 2
fi

da=$(itemAt 3 "$param")
if ! $(isInteger $da); then
	return 2
fi
nod=$(daysInMonth $y4)
if [ $da -lt 1 -o $da -gt $(itemAt $mo "$nod") ]; then
	echo false
	return 2
fi

echo true

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

function isDateTime() {
if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")
if [ $c -ne 6 ]; then
	echo false
	return 2
fi

y4=$(itemAt 1 "$param")
mo=$(itemAt 2 "$param")
da=$(itemAt 3 "$param")
if ! $(isDate "$y4 $mo $da"); then
	echo false
	return 2
fi

hr=$(itemAt 4 "$param")
mi=$(itemAt 5 "$param")
se=$(itemAt 6 "$param")
if ! $(isTime "$hr $mi $se"); then
	echo false
	return 2
fi

echo true

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Date/Time
}

function isTime() {
if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")
if [ $c -ne 3 ]; then
	echo false
	return 2
fi

hr=$(itemAt 1 "$param")
if ! $(isInteger $hr); then
	return 2
fi
if [ $hr -lt 0 -o $hr -gt 23 ]; then
	echo false
	return 2
fi

mi=$(itemAt 2 "$param")
if ! $(isInteger $mi); then
	return 2
fi
if [ $mi -lt 0 -o $mi -gt 59 ]; then
	echo false
	return 2
fi

se=$(itemAt 3 "$param")
if ! $(isInteger $se); then
	return 2
fi
if [ $se -lt 0 -o $se -gt 59 ]; then
	echo false
	return 2
fi

echo true

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid time
}

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
setSystemLanguage "C"
totalSec=$(echo "$totalSec" | awk '{printf("%.0f", $0)}')
setSystemLanguage ""

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

function Minutes2Time() {
if [ $# -ne 1 ]; then
	return 1
fi

Minutes=$1
if ! $(isInteger $Minutes); then
	return 2
fi

if [ $Minutes -lt 0 -o $Minutes -gt 1439 ]; then
	return 3
fi

hr=$(($Minutes / 60))
mi=$(($Minutes % 60))

Time="$hr $mi 0"

echo "$Time"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - DayMin is not integer
# 3 - DayMin is out of range
}

function monthOfDOY() {
if [ $# -ne 2 ]; then
	return 1
fi

y4=$1
if [ $y4 -lt $MinimumYear ]; then
	return 2
fi

doy=$2
if $(isLeapYear $y4); then
	MaximumDOY=366
else
	MaximumDOY=365
fi
if [ $doy -lt 1 -o $doy -gt $MaximumDOY ]; then
	return 2
fi

nod=$(daysInMonth $y4)

m=1
r=$doy

for i in $nod; do
	if [ $r -gt $i ]; then
		m=$(($m + 1))
		r=$(($r - $i))
	else
		break
	fi
done

echo "$m"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

function Now() {
if [ $# -gt 1 ]; then
	return 1
fi

utcdate=false

if [ $# -ne 0 ]; then
	param=$1
	case $param in
			-u | --utc)
				utcdate=true
				;;
	esac
fi

if $utcdate; then
	DATE="date -u"
else
	DATE="date"
fi

y4=$($DATE +%Y)
hr=$(echo "$($DATE +%H)" | sed 's/^0//')
mi=$(echo "$($DATE +%M)" | sed 's/^0//')
se=$(echo "$($DATE +%S)" | sed 's/^0//')
mo=$(echo "$($DATE +%m)" | sed 's/^0//')
da=$(echo "$($DATE +%d)" | sed 's/^0//')

echo "$y4 $mo $da $hr $mi $se"

return 0

# Return codes
# 0 - OK
# 1 - Excessive parameters
}

function shortYear() {
if [ $# -ne 1 ]; then
	return 1
fi

y4=$1
if ! $(isInteger $y4); then
	return 2
fi
if [ $y4 -lt $MinimumYear ]; then
	return 3
fi

y2=$(echo $y4 | sed 's/^..//')

echo "$y2"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MININUM
}

function Time2Minutes() {
if [ $# -ne 1 ]; then
	return 1
fi

Time="$1"
if ! $(isTime "$Time"); then
	return 2
fi

hr=$(itemAt 1 "$Time")
mi=$(itemAt 2 "$Time")

Minutes=$(($(($hr * 60)) + $mi))

echo "$Minutes"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid time
}
