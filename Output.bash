#!/bin/bash

# Required Libraries
. Lists.bash
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

function terminalSize() {
echo $(stty size)

return 0

# Return codes
# 0 - OK
}

function gotoxy() {
if [ $# -ne 2 ]; then
	return 1
fi

x=$1
if ! $(isInteger $x); then
	return 2
fi
x_max=$(itemAt 2 "$(terminalSize)")
if [ $x -gt $x_max ]; then
	return 2
fi

y=$2
if ! $(isInteger $y); then
	return 2
fi
y_max=$(itemAt 1 "$(terminalSize)")
if [ $y -gt $y_max ]; then
	return 2
fi

echo -en "\e[""$y"";""$x""f"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid position
}

function colorReset() {
echo -en "\e[0m"

return 0

# Return codes
# 0 - OK
}

function colourReset() {
colorReset $@	
}

function setBgColor() {
if [ $# -ne 1 ]; then
	return 1
fi

color=$1

case $color in
	"none")
		colorReset
		;;
	"black" | "gray" | "grey")
		echo -en "\e[40m"
		;;
	"blue")
		echo -en "\e[44m"
		;;
	"brown")
		echo -en "\e[43m"
		;;
	"cyan")
		echo -en "\e[46m"
		;;
	"green")
		echo -en "\e[42m"
		;;
	"purple")
		echo -en "\e[45m"
		;;
	"red")
		echo -en "\e[41m"
		;;
	"light-gray" |"light-grey")
		echo -en "\e[47m"
		;;
	*)
		return 2
		;;
esac

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid color
}

function setBgColour() {
setBgColor $@
}

function setTextColor() {
if [ $# -ne 1 ]; then
	return 1
fi

color=$1

case $color in
	"none")
		colorReset
		;;
	"black" | "gray" | "grey")
		echo -en "\e[0;30m"
		;;
	"blue")
		echo -en "\e[0;34m"
		;;
	"brown")
		echo -en "\e[0;33m"
		;;
	"cyan")
		echo -en "\e[0;36m"
		;;
	"green")
		echo -en "\e[0;32m"
		;;
	"purple")
		echo -en "\e[0;35m"
		;;
	"red")
		echo -en "\e[0;31m"
		;;
	"light-gray" |"light-grey")
		echo -en "\e[0;37m"
		;;
	"dark-black" | "dark-gray" | "dark-grey")
		echo -en "\e[1;30m"
		;;
	"light-blue")
		echo -en "\e[1;34m"
		;;
	"yellow")
		echo -en "\e[1;33m"
		;;
	"light-cyan")
		echo -en "\e[1;36m"
		;;
	"light-green")
		echo -en "\e[1;32m"
		;;
	"light-purple")
		echo -en "\e[1;35m"
		;;
	"light-red")
		echo -en "\e[1;31m"
		;;
	"white")
		echo -en "\e[1;37m"
		;;
	*)
		return 2
		;;
esac

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid color
}

function setTextColour() {
setTextColor $@
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
