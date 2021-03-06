#!/bin/bash

load numbers.isInteger
load strings.strlen

function substring() {
if [ $# -ne 3 ]; then
	return 1
fi

p1="$1"
if ! $(isInteger "$p1"); then
	return 2
fi

p2="$2"
if ! $(isInteger "$p2"); then
	return 2
fi

str="$3"

len=$(strlen "$str")
if [ $len -eq 0 ]; then
	return 2
fi


if [ $p1 -lt 1 -o $p1 -gt $len ]; then
	return 2
fi


if [ $p2 -lt 1 -o $p2 -gt $len ]; then
	return 2
fi

if [ $p1 -gt $p2 ]; then
	return 2
fi

substr=$(cut -c $p1-$p2 <<< "$str")

echo "$substr"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments 
}
