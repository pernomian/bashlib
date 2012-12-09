#!/bin/bash

load numbers.isInteger
load strings.strlen
load strings.substring

function isGNSSDate() {
if [ $# -ne 1 ]; then
	return 1
fi

arg="$1"

ans=false

if [ $(strlen "$arg") -eq 5 ]; then
	if $(isInteger "$arg"); then
		if [ $arg -gt 0 ]; then
			end=$(substring 5 5 "$arg")
			if [ $end -ge 0 -a $end -le 6 ]; then
				ans=true
			fi
		fi
	fi
fi

echo $ans

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
