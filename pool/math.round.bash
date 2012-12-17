#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function round() {
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

eval awk "'{ printf(\"%.""$dp""f\n\", \$1) }'" <<< "$num"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
