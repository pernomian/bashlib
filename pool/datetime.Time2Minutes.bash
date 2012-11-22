#!/bin/bash

load datetime.isTime
load lists.itemAt

function Time2Minutes() {
if [ $# -ne 1 ]; then
	return 1
fi

Time="$1"
if ! $(isTime "$Time"); then
	return 2
fi

hr=$(itemAt 1 "$Time")
mi=$(itemAt 2 "$Time")

Minutes=$(($(($hr * 60)) + $mi))

echo "$Minutes"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid time
}
