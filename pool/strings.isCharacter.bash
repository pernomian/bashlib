#!/bin/bash

load strings.strlen

function isCharacter() {
if [ $# -ne 1 ]; then
	return 1
fi

arg="$1"

if [ $(strlen "$arg") -eq 1 ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
#0 - OK
#1 - Not enough arguments
}
