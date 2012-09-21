#!/bin/bash

. DateTime.bash

myDate=$(currentDateTime)
echo $myDate

DOY=$(Date2DOY 2012 8 6)
echo $DOY

Date=$(DOY2Date 2012 219)
echo $Date

Time=$(DayMin2Time 720)
echo $Time

DayMin=$(Time2DayMin 12 0)
echo $DayMin

nod=$(daysInMonth 2012)
echo $nod

refdate="2012 8 6"
yesterday=$(incrementDate -1 "$refdate") # Note the quotes to distinguish the list.
echo $yesterday
onceuponatime=$(incrementDate -10000 "2012 9 21")
echo $onceuponatime
tomorrow=$(incrementDate 1 "2012 8 6")
echo $tomorrow
oneweekafter=$(incrementDate 7 "2012 8 6")
echo $oneweekafter

before10=$(incrementTime -10 "12 50")
echo $before10
after10=$(incrementTime 10 "12 50")
echo $after10

for y4 in $(seq 2000 1 2012); do
	if $(isLeapYear $y4); then
		echo "$y4 é bissexto"
	else
		echo "$y4 é normal"
	fi 
done

date1="2012 8 6"
if $(isValidDate "$date1"); then
	echo "\"$date1\" é válida."
else
	echo "\"$date1\" é inválida!"
fi
date2="2011 2 29"
if $(isValidDate "$date2"); then
	echo "\"$date2\" é válida."
else
	echo "\"$date2\" é inválida!"
fi

time1="13 5"
if $(isValidTime "$time1"); then
	echo "\"$time1\" é válido."
else
	echo "\"$time1\" é inválido!"
fi
time2="0 60"
if $(isValidTime "$time2"); then
	echo "\"$time2\" é válido."
else
	echo "\"$time2\" é inválido!"
fi
time3="0 30 59"
if $(isValidTime "$time3"); then
	echo "\"$time3\" é válido."
else
	echo "\"$time3\" é inválido!"
fi
time4="0 30 60"
if $(isValidTime "$time4"); then
	echo "\"$time4\" é válido."
else
	echo "\"$time4\" é inválido!"
fi

month=$(monthOfDOY 2012 219)
echo "O mês do dia do ano 219 de 2012 é $month."

y2=$(shortYear 2012)
echo "O ano curto de 2012 é $y2."

JDN=$(Date2JDN 2012 9 20)
echo "O JDN de 20/9/2012 é $JDN"

Date=$(JDN2Date 2456191)
echo "A data de JDN 2456191 é $Date"

JD=$(DateTime2JD 2012 9 20 16 30 0)
echo "O JD de 20/9/2012 16:30:00 é $JD"


exit 0

