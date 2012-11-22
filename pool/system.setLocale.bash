#!/bin/bash

function setLocale() {
if [ $# -ne 1 ]; then
	return 1
fi

LC_ALL=$1
export LC_ALL

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
