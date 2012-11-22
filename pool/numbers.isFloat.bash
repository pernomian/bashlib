#!/bin/bash

load numbers.isNumber

function isFloat() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1

if $(isNumber $param); then
	if [ -n "$(echo "$param" | grep '\.')" ]; then
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
