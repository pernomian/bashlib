#!/bin/bash

# Required Libraries
. Numbers.bash
# ---

function addLeadingZeros() {
if [ $# -ne 2 ]; then
	echo ""
	return 1
fi

len=$1
if ! $(isInteger $len); then
	return 2
fi
if [ $len -lt 1 ]; then
	return 2
fi
num=$2
if ! $(isInteger $len); then
	return 2
fi

setSystemLanguage "C"
printf "%0""$len""d" $num
setSystemLanguage ""

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Length and/or Number
}

function setSystemLanguage() {
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

function writeLog() {
if [ $# -ne 3 ]; then
	return 1
fi

kind="$1"
text="$2"
fpath="$3"

line="$(date +%Y-%m-%d" "%H:%M:%S)"

case $kind in
	--begin | -B | --end | -e)
		line="$line   \033[1m[*]"
		;;
	--info | -i)
		line="$line   \033[0;34m[i]"
		;;
	--warning | -W)
		line="$line   \033[0;33m[!]"
		;;
	--error | -X)
		line="$line   \033[0;31m[X]"
		;;
	*)
		return 2
		;;
esac
	
if [ -z "$text" ]; then
	return 3
fi

if [ ! -f $path ]; then
	return 4
fi

line="$line $text\033[0m"

echo -e $line >> $fpath

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Kind
# 3 - Empty Message
# 4 - File does not exist
}
