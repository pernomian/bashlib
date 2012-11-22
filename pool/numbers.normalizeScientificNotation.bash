#!/bin/bash

load numbers.isScientificNotation
load numbers.isInteger
load numbers.normalizeInteger
load numbers.isFloat
load numbers.normalizeFloat

function normalizeScientificNotation() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isScientificNotation $param); then
	return 2
fi

#    Chosen method: split the number at the "exp" (E/e) symbol:
#    1. The left part is normalized by using "normalizeFloat" or
# "normalizeInteger" 
#    2. The right part is normalized by using "normalizeInteger".

lower=$(echo "$param" | grep "e")
if [ -n "$lower" ]; then
	exp="e"
fi

upper=$(echo "$param" | grep "E")
if [ -n "$upper" ]; then
	exp="E"
fi

left=$(echo "$param" | cut -d "$exp" -f 1)
if $(isInteger $left); then
	lnorm=$(normalizeInteger $left)
fi
if $(isFloat $left); then
	lnorm=$(normalizeFloat $left)
fi

right=$(echo "$param" | cut -d "$exp" -f 2)
rnorm=$(normalizeInteger $right)

res="$lnorm""$exp""$rnorm"
echo $res
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not scientific notation
}
