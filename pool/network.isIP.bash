#!/bin/bash

function isIP() {
if [ $# -ne 1 ]; then
	return 1
fi

# Regular Expression based in Aurelio Jargas' example
# Available at "http://aurelio.net/regex/casar-ip.html"
if [ -n "$(grep -x '\(\(\(1[0-9]\|[1-9]\?\)[0-9]\|2\([0-4][0-9]\|5[0-5]\)\)\.\)\{3\}\(\(1[0-9]\|[1-9]\?\)[0-9]\|2\([0-4][0-9]\|5[0-5]\)\)' <<< "$1")" ]; then
	echo true
else
	echo false
fi

return 0
# 0 - OK
# 1 - Not enough arguments
}
