#!/bin/bash

. DateTime.bash

now=$(Now)
echo "Now is $now"

Date="2012 8 6"
DOY=$(Date2DOY "$Date")
echo "DOY of $Date is $DOY"

Year=2012
DOY=219
Date=$(DOY2Date $Year $DOY)
echo "$Year $DOY is $Date"

Minutes=720
Time=$(Minutes2Time $Minutes)
echo "Time of $Minutes is $Time"

Time="12 0 5"
Minutes=$(Time2Minutes "$Time")
echo "Minute of $Time is $Minutes"

Year=2012
nod=$(daysInMonth $Year)
echo "The number of days in month for $Year is $nod"

Date="2012 8 6"
previousDay=$(incrementDay -1 "$Date")
echo "The previous day of $Date is $previousDay"
previousWeek=$(incrementDay -7 "$Date")
echo "The previous week of $Date is $previousWeek"
nextDay=$(incrementDay 1 "$Date")
echo "The next day of $Date is $nextDay"
nextWeek=$(incrementDay 7 "$Date")
echo "The next week of $Date is $nextWeek"

Time="12 50 30"
previous10=$(incrementMinute -10 "$Time")
echo "Time is $Time. 10 minutes ago was $previous10"
next10=$(incrementMinute 10 "$Time")
echo "Time is $Time. Next 10 minutes will be $next10"

for Year in {2008..2012}; do
	if $(isLeapYear $Year); then
		echo "$Year is Leap Year"
	else
		echo "$Year is Normal Year"
	fi 
done

Date1="2012 8 6"
if $(isDate "$Date1"); then
	echo "$Date1 is Date"
else
	echo "$Date1 is not Date!"
fi
Date2="2011 2 29"
if $(isDate "$Date2"); then
	echo "$Date2 is Date"
else
	echo "$Date2 is not Date!"
fi

Time1="0 30 59"
if $(isTime "$Time1"); then
	echo "$Time1 is Time"
else
	echo "$Time1 is not Time!"
fi
Time2="0 30 60"
if $(isTime "$Time2"); then
	echo "$Time2 is Time"
else
	echo "$Time2 is not Time!"
fi

DateTime1="2011 2 28 0 35 20"
if $(isDateTime "$DateTime1"); then
	echo "$DateTime1 is DateTime"
else
	echo "$DateTime1 is not DateTime!"
fi
DateTime2="2011 2 29 0 35 20"
if $(isDateTime "$DateTime2"); then
	echo "$DateTime2 is DateTime"
else
	echo "$DateTime2 is not DateTime!"
fi
DateTime3="2012 2 29 0 30 60"
if $(isDateTime "$DateTime3"); then
	echo "$DateTime3 is DateTime"
else
	echo "$DateTime3 is not DateTime!"
fi

Month=$(monthOfDOY 2012 219)
echo "Month of DOY 219 of 2012 is $Month"

y2=$(shortYear 2012)
echo "Short Year of 2012 is $y2"

Date="2012 9 20"
JDN=$(Date2JDN "$Date")
echo "JDN of $Date is $JDN"

JDN=2456191
Date=$(JDN2Date $JDN)
echo "Date of JD#$JDN is $Date"

DateTime="2012 9 20 11 59 59"
JD=$(DateTime2JD "$DateTime")
echo "JD of $DateTime is $JD"

JD=2456190.999988426
DateTime=$(JD2DateTime $JD)
echo "DateTime of $JD is $DateTime"

Date1="2011 1 1"
Date2="2012 12 31"
dJDN=$(deltaDay "$Date1" "$Date2")
echo "There are $dJDN days between $Date1 and $Date2"

DateTime1="2012 1 1 0 0 0"
DateTime2="2013 12 31 23 59 59"
dSec=$(deltaSecond "$DateTime1" "$DateTime2")
echo "There are $dSec seconds between $DateTime1 and $DateTime2"

exit 0
