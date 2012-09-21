#!/bin/bash

# Required Libraries
# ---

function addLeadingZeros {
if [ $# -ne 2 ]; then
	echo ""
	return 1
fi

len=$1
num=$2

printf "%0""$len""d" $num
}

function writeLog {
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
		return 1
		;;
esac
	
if [ -z "$text" ]; then
	return 1
fi

line="$line $text\033[0m"
echo -e $line >> $fpath
return 0
}
