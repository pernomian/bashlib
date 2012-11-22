#!/bin/bash

function Now() {
if [ $# -gt 1 ]; then
	return 1
fi

utcdate=false

if [ $# -ne 0 ]; then
	param=$1
	case $param in
			-u | --utc)
				utcdate=true
				;;
	esac
fi

if $utcdate; then
	DATE="date -u"
else
	DATE="date"
fi

y4=$($DATE +%Y)
hr=$(echo "$($DATE +%H)" | sed 's/^0//')
mi=$(echo "$($DATE +%M)" | sed 's/^0//')
se=$(echo "$($DATE +%S)" | sed 's/^0//')
mo=$(echo "$($DATE +%m)" | sed 's/^0//')
da=$(echo "$($DATE +%d)" | sed 's/^0//')

echo "$y4 $mo $da $hr $mi $se"

return 0

# Return codes
# 0 - OK
# 1 - Excessive parameters
}
