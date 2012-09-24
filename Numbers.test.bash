#!/bin/bash

# Required Libraries
. Numbers.bash
# ---

input=123.456
if $(isFloat $input); then
	echo "$input is float"
fi

input=123
if $(isInteger $input); then
	echo "$input is integer"
fi

input=1234.5678e-9
if $(isNumber $input); then
	echo "$input is number"
fi

input=123.456e7
if $(isScientificNotation $input); then
	echo "$input is scientific notation"
fi

input=-.1230
echo "Input  : $input"
output=$(normalizeFloat $input)
echo "Output : $output"

input=+000123
echo "Input  : $input"
output=$(normalizeInteger $input)
echo "Output : $output"

input=-.1230e-04
echo "Input  : $input"
output=$(normalizeNumber $input)
echo "Output : $output"

input=-.123000e+004
echo "Input  : $input"
output=$(normalizeScientificNotation $input)
echo "Output : $output"

exit 0
