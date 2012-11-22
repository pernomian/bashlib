#!/bin/bash

load numbers.isNumber

function isInteger() {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

param=$1

if $(isNumber $param); then
	if [ -z "$(echo "$param" | grep '\.')" ]; then
		if [ -z "$(echo "$param" | grep '[Ee]')" ]; then
			echo true
		else
			echo false
		fi
	else
		echo false
	fi
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
