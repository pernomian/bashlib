#!/bin/bash

# Required libraries
# ---

function GPSDate() {
if [ $# -ne 2 ]; then
	echo "00000"
	return 1
fi

y4=$1
doy=$(echo $2 | sed 's/^0*//')

ndoy=0
for y in $(seq 1980 1 $y4); do
	if [ $y -eq 1980 ]; then
		if [ $y -eq $y4 ]; then
			if [ $doy -le 6 ]; then
				ndoy=$(($ndoy + 0))
			else
				ndoy=$(($ndoy + $(($doy - 6))))
			fi
		else
			ndoy=$(($ndoy + 360))
		fi
	elif [ $y -gt 1980 -a $y -lt $y4 ]; then
		if [ $(($y % 4)) -eq 0 ]; then
			ndoy=$(($ndoy + 366))
		else
			ndoy=$(($ndoy + 365))
		fi
	else
		ndoy=$(($ndoy + $doy))
	fi
done

gps_week=$(($ndoy / 7))
gps_weekday=$(($ndoy % 7))

gps_date=$(echo "$gps_week $gps_weekday" | awk '{printf("%04d%1d", $1, $2)}')

echo $gps_date

return 0

# Return codes
# 0 - Calculation success
# 1 - Calculation ERROR
}
