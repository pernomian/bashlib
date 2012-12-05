#!/bin/bash

load lists.itemAt
load lists.sizeOfList

function isDelta() {
if [ $# -ne 1 ]; then
	return 1
fi

delta="$1"

if [ $(sizeOfList "$delta") -ne 4 ]; then
	echo false
	return 2
fi

Day=$(itemAt 1 "$delta")
Hour=$(itemAt 2 "$delta")
Min=$(itemAt 3 "$delta")
Sec=$(itemAt 4 "$delta")
if ! $(isInteger $Day) || \
   ! $(isInteger $Hour) || \
   ! $(isInteger $Min) || \
   ! $(isInteger $Sec); then
	echo false
	return 2
fi
if [ $Hour -lt -23 -o $Hour -gt 23 ]; then
	echo false
	return 2
fi
if [ $Min -lt -59 -o $Min -gt 59 ]; then
	echo false
	return 2
fi
if [ $Sec -lt -59 -o $Sec -gt 59 ]; then
	echo false
	return 2
fi

negatives=0
if [ $Day -lt 0 ]; then
	negatives=$(($negatives + 1))
fi
if [ $Hour -lt 0 ]; then
	negatives=$(($negatives + 1))
fi
if [ $Min -lt 0 ]; then
	negatives=$(($negatives + 1))
fi
if [ $Sec -lt 0 ]; then
	negatives=$(($negatives + 1))
fi
if [ $negatives -gt 1 ]; then
	echo false
	return 2
fi

if [ $Hour -lt 0 ]; then
	if [ $Day -ne 0 ]; then
		echo false
		return 2
	fi
fi
if [ $Min -lt 0 ]; then
	if [ $Day -ne 0 -o $Hour -ne 0 ]; then
		echo false
		return 2
	fi
fi
if [ $Sec -lt 0 ]; then
	if [ $Day -ne 0 -o $Hour -ne 0 -o $Min -ne 0 ]; then
		echo false
		return 2
	fi
fi

echo true

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
