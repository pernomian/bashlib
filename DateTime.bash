#!/bin/bash

# Required Libraries
. Lists.bash
. Numbers.bash
# ---

# Initialization
MinimumYear=1970
# ---

function currentDateTime {
utcdate=false
doyformat=false

if [ $# -eq 0 -o $# -ge 3 ]; then
	utcdate=false
	doyformat=false
else
	for param in $*; do
		case $param in
			-u | --utc)
				utcdate=true
				;;
			-D | --doy)
				doyformat=true
				;;
		esac
	done
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

if $doyformat; then
	doy=$(echo "$($DATE +%j)" | sed 's/^0*//')
	echo "$y4 $doy $hr $mi $se"
else
	mo=$(echo "$($DATE +%m)" | sed 's/^0//')
	da=$(echo "$($DATE +%d)" | sed 's/^0//')
	echo "$y4 $mo $da $hr $mi $se"
fi

return 0

# Return codes
# 0 - OK
}

function Date2DOY {
if [ $# -ne 3 ]; then
	return 1
fi

y4=$1
mo=$(echo "$2" | sed 's/^0//')
da=$(echo "$3" | sed 's/^0//')

if ! $(isValidDate "$y4 $mo $da"); then
	return 2
fi

doy=0
nod=$(daysInMonth $y4)
for m in $(seq 1 1 $(($mo - 1))); do
	doy=$(($doy + $(itemAt $m "$nod")))
done
doy=$(($doy + $da))

echo "$y4 $doy"
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

function Date2JDN() {
if [ $# -ne 3 ]; then
	return 1
fi
y4=$1
mo=$(echo "$2" | sed 's/^0//')
da=$(echo "$3" | sed 's/^0//')

if ! $(isValidDate "$y4 $mo $da"); then
	return 2
fi

a=$(echo "scale=0; (14 - $mo) / 12" | bc)
y=$(echo "$y4 + 4800 -$a" | bc)
m=$(echo "$mo + 12 * $a - 3" | bc)
JDN=$(echo "scale=0; $da + (153 * $m + 2) / 5 + 365 * $y + $y / 4 \
    - $y / 100 + $y / 400 - 32045" | bc)

echo $JDN
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

function DateTime2JD() {
if [ $# -ne 6 ]; then
	return 1
fi

y4=$1
mo=$2
da=$3
hr=$4
mi=$5
se=$6

if ! $(isValidDate "$y4 $mo $da"); then
	return 2
fi

if ! $(isValidTime "$hr $mi $se"); then
	return 2
fi

JDN=$(Date2JDN $y4 $mo $da)

JD=$(echo "scale=6; $JDN + ($hr - 12) / 24.0 + $mi / 1440.0 \
   + $se / 86400.0" | bc)

echo $JD
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date and/or time
}

function DayMin2Time {
if [ $# -ne 1 ]; then
	return 1
fi

dami=$1
if ! $(isInteger $dami); then
	return 2
fi

if [ $dami != "0" ]; then
	dami=$(echo "$1" | sed 's/^0*//')
fi

if [ $dami -lt 0 -o $dami -gt 1439 ]; then
	return 3
fi

hr=$(($dami / 60))
mi=$(($dami % 60))

time="$hr $mi"
echo "$time"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - DayMin is not integer
# 3 - DayMin is out of range
}

function daysInMonth {
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

function DOY2Date {
if [ $# -ne 2 ]; then
	return 1
fi

y4=$1
doy=$(echo "$2" | sed 's/^0*//')

if ! $(isValidDate "$y4 $doy"); then
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

function incrementDate {
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

date="$2"
if ! $(isValidDate "$date"); then
	return 4
fi

c=$(sizeOfList "$date")

if [ $c -eq 2 ]; then
	doyformat=true
else
	doyformat=false
fi

cy4=$(itemAt 1 "$date")

if $doyformat; then
	cdoy=$(echo "$(itemAt 2 "$date")" | sed 's/^0*//')
	
	cmo=$(itemAt 2 "$(DOY2Date $cy4 $cdoy)")
	cda=$(itemAt 3 "$(DOY2Date $cy4 $cdoy)")
else
	cmo=$(echo "$(itemAt 2 "$date")" | sed 's/^0//')
	cda=$(echo "$(itemAt 3 "$date")" | sed 's/^0//')
fi

cJDN=$(Date2JDN $cy4 $cmo $cda)

nJDN=$(($cJDN + $inc))

nDate=$(JDN2Date $nJDN)
ny4=$(itemAt 1 "$nDate")
nmo=$(itemAt 2 "$nDate")
nda=$(itemAt 3 "$nDate")

if $doyformat; then
	ndoy=$(itemAt 2 "$(Date2DOY $ny4 $nmo $nda)")
	echo "$ny4 $ndoy"
else
	echo "$ny4 $nmo $nda"
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Increment not integer
# 3 - Increment out of allowed range
# 4 - Invalid date
}

function incrementTime {
if [ $# -ne 2 ]; then
	return 1
fi

inc=$1
if ! $(isInteger $inc); then
	return 2
fi

incmin=-1439
incmax=1439
if [ $inc -lt $incmin -o $inc -gt $incmax ]; then
	return 3
fi

time="$2"
if ! $(isValidTime "$time"); then
	return 4
fi

currentHour=$(itemAt 1 "$time")
currentMin=$(itemAt 2 "$time")

currentDayMin=$(Time2DayMin $currentHour $currentMin)

newDayMin=$(($currentDayMin + $inc))

if [ $newDayMin -lt 0 ]; then
	newDayMin=$((1440 + $newDayMin))
fi

if [ $newDayMin -gt 1439 ]; then
	newDayMin=$(($newDayMin - 1440))
fi

newTime=$(DayMin2Time $newDayMin)
newHour=$(itemAt 1 "$newTime")
newMin=$(itemAt 2 "$newTime")

echo "$newHour $newMin"
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

function isValidDate() {
if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")

if [ $c -lt 2 -o $c -gt 3 ]; then
	echo false
	return 2
fi

if [ $c -eq 2 ]; then
	y4=$(itemAt 1 "$param")
	if ! $(isInteger $y4); then
		return 2
	fi
	if [ $y4 -lt $MinimumYear ]; then
		echo false
		return 2
	fi
	
	doy=$(echo "$(itemAt 2 "$param")" | sed 's/^0*//')
	if ! $(isInteger $doy); then
		return 2
	fi
	if $(isLeapYear $y4); then
		doymax=366
	else
		doymax=365
	fi
	if [ $doy -lt 1 -o $doy -gt $doymax ]; then
		echo false
		return 2
	fi
	
	echo true
	return 0
fi

if [ $c -eq 3 ]; then
	y4=$(itemAt 1 "$param")
	if ! $(isInteger $y4); then
		return 2
	fi
	if [ $y4 -lt $MinimumYear ]; then
		echo false
		return 2
	fi
	
	mo=$(echo "$(itemAt 2 "$param")" | sed 's/^0*//')
	if ! $(isInteger $mo); then
		return 2
	fi
	if [ $mo -lt 1 -o $mo -gt 12 ]; then
		echo false
		return 2
	fi
	
	da=$(echo "$(itemAt 3 "$param")" | sed 's/^0*//')
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
fi

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
}

function isValidTime() {
if [ $# -ne 1 ]; then
	return 1
fi

param="$1"

c=$(sizeOfList "$param")

if [ $c -lt 2 -o $c -gt 3 ]; then
	echo false
	return 2
fi

hr=$(itemAt 1 "$param")
if ! $(isInteger $hr); then
	return 2
fi
if [ "$hr" != "0" ]; then
	hr=$(echo "$(itemAt 1 "$param")" | sed 's/^0//')
fi
if [ $hr -lt 0 -o $hr -gt 23 ]; then
	echo false
	return 2
fi

mi=$(itemAt 2 "$param")
if ! $(isInteger $mi); then
	return 2
fi
if [ "$mi" != "0" ]; then
	mi=$(echo "$(itemAt 2 "$param")" | sed 's/^0//')
fi
if [ $mi -lt 0 -o $mi -gt 59 ]; then
	echo false
	return 2
fi

if [ $c -eq 3 ]; then
	se=$(itemAt 3 "$param")
	if ! $(isInteger $se); then
		return 2
	fi
	if [ "$se" != "0" ]; then
		se=$(echo "$(itemAt 3 "$param")" | sed 's/^0//')
	fi
	if [ $se -lt 0 -o $se -gt 59 ]; then
		echo false
		return 2
	fi
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

th=$(echo "$Jfrac * 24.0" | bc)
TH=$(echo "scale=0; $th / 1" | bc)
tm=$(echo "($th - $TH) * 60.0" | bc)
TM=$(echo "scale=0; $tm / 1" | bc)
ts=$(echo "($tm - $TM) * 60.0" | bc)
TS=$(echo "scale=0; $ts / 1" | bc)

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

function monthOfDOY() {
if [ $# -ne 2 ]; then
	return 1
fi

y4=$1
doy=$(echo "$2" | sed 's/^0*//')

if ! $(isValidDate "$y4 $doy"); then
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

echo $m
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid date
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
echo $y2

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Year is not integer
# 3 - Year is LESSER THAN the MININUM
}

function Time2DayMin() {
if [ $# -ne 2 ]; then
	return 1
fi

hr=$1
if [ "$hr" != "0" ]; then
	hr=$(echo "$hr" | sed 's/^0//')
fi

mi=$2
if [ "$mi" != "0" ]; then
	mi=$(echo "$mi" | sed 's/^0//')
fi

if ! $(isValidTime "$hr $mi"); then
	return 2
fi

dami=$(($(($hr * 60)) + $mi))

echo $dami
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid time
}
