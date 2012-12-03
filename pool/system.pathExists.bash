#!/bin/bash

load system.isPath

function pathExists() {
if [ $# -ne 1 ]; then
	return 1
fi

path=$1
if ! $(isPath "$path"); then
	return 2
fi

if [ -e $path ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid path
}
