#!/bin/bash

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
