#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function sin() {
if [ $# -ne 1 ]; then
	return 1
fi

x="$1"
if ! $(isInteger $x) && ! $(isFloat $x); then
	return 2
fi

ans=$(bc -l <<< "scale=20; s($x)")

awk '{ printf("%.16f\n", $1) }' <<< "$ans"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
