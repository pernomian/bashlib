#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function roundUp() {
if [ $# -ne 2 ]; then
	return 1
fi

num="$1"
if ! $(isInteger "$num") && ! $(isFloat "$num"); then
	return 2
fi

dp="$2"
if ! $(isInteger "$dp"); then
	return 2
fi
if [ $dp -lt 0 -o $dp -gt 16 ]; then
	return 2
fi

ans=$(bc -l <<< "scale=$dp; $num / 1 + 1 / 10^$dp")
if [ $(bc -l <<< "scale=$dp; ($ans - $num) * 10^$dp == 1.0") -eq 1 ]; then
	ans=$num
fi

echo $ans

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
