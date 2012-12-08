#!/bin/bash

load lists.sequence

function strjoin() {
if [ $# -lt 1 ]; then
	return 1
fi

str=""
for i in $(sequence "1-$#"); do
	str="$str""$1"
	shift
done

echo "$str"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
