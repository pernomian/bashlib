#!/bin/bash

function append() {
if [ $# -ne 2 ]; then
	return 1
fi

item="$1"
list="$2"

newlist="$list"
if [ $(strlen "$item") -gt 0 ]; then
	newlist="$newlist $item"
fi

echo "$newlist"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
