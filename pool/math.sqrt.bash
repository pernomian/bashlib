#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function sqrt() {
if [ $# -ne 1 ]; then
	return 1
fi

x="$1"
if ! $(isInteger $x) && ! $(isFloat $x); then
	return 2
fi
if [ $(bc -l <<< "$x <= 0.0") -eq 1 ]; then
	return 2
fi

ans=$(bc -l <<< "scale=20; sqrt($x)")

awk '{ printf("%.16f\n", $1) }' <<< "$ans"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
