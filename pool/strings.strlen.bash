#!/bin/bash

function strlen() {
if [ $# -ne 1 ]; then
	return 1
fi

str="$1"

echo ${#str}

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
