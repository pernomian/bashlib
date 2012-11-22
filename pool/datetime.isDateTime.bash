#!/bin/bash

load lists.sizeOfList
load lists.itemAt
load datetime.isDate
load datetime.isTime

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
