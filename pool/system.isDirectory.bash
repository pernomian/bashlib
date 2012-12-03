#!/bin/bash

load system.isPath

function isDirectory() {
if [ $# -ne 1 ]; then
	return 1
fi

path=$1
if ! $(isPath "$path"); then
	return 2
fi

if [ -d $path ]; then
	echo true
else
	echo false
fi

return 0

# Return code
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid path
}
