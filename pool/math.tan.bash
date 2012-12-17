#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function tan() {
if [ $# -ne 1 ]; then
	return 1
fi

x="$1"
if ! $(isInteger $x) && ! $(isFloat $x); then
	return 2
fi

ans=$(bc -l <<< "define tan(x) {return s(x)/c(x)}; scale=20; tan($x)")

awk '{ printf("%.16f\n", $1) }' <<< "$ans"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
