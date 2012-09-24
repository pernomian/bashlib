#!/bin/bash

# Required Libraries
# ---

function isFloat() {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

param=$1

if $(isNumber $param); then
	if [ -n "$(echo "$param" | grep '\.')" ]; then
		if [ -z "$(echo "$param" | grep '[Ee]')" ]; then
			echo true
		else
			echo false
		fi
	else
		echo false
	fi
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function isInteger() {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

param=$1

if $(isNumber $param); then
	if [ -z "$(echo "$param" | grep '\.')" ]; then
		if [ -z "$(echo "$param" | grep '[Ee]')" ]; then
			echo true
		else
			echo false
		fi
	else
		echo false
	fi
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function isNumber() {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

param=$1

gexpr='^[-+]\?[0-9]*\.\?[0-9]*\([Ee][-+]\?[0-9]\+\)\?$'
res=$(echo $param | grep -x "$gexpr")
# NOTE: grep -x forces a line match (POSIX compliant)

# Test if $res return a non-zero string (number is valid)
if [ -n "$res" ]; then
	# Check if resulting number doesn't begin with [Ee]
	sciweird=$(echo "$res" | grep '^[-+]\?\.\?[Ee]\|[Ee]$')
	if [ -z "$sciweird" ]; then
		echo true
	else
		echo false
	fi
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function isScientificNotation() {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

param=$1

if $(isNumber $param); then
	if [ -n "$(echo "$param" | grep '[Ee]')" ]; then
		echo true
	else
		echo false
	fi
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function normalizeFloat() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isFloat $param); then
	return 2
fi

#    Chosen method: split the number at the floating point:
#    1. The integer part is normalized by using "normalizeInteger"
#    2. The float part is normalized by removing the trailing zeros
#       If the float part is omitted, a zero is added after the floating
#    point

# Splitting
integer=$(echo "$param" | cut -d "." -f 1)
#    If the integer part is empty, a null argument is passed to
# "normalizeInteger"
#    To avoid this, this check defines integer=0
if [ -z "$integer" ]; then
	integer=0
fi
#    But when redefining integer=0, the negative/positive information
# get lost, so this additional check memorizes when an integer is
# negative by holding the "-" whether necessary
if [ -n "$(echo "$integer" | grep "^-")" ]; then
	sig="-"
else
	sig=""
fi

float=$(echo "$param" | cut -d "." -f 2)

# Normalizing integer part
inorm=$(normalizeInteger $integer)
#    In the previous signal check, if the number is negative, sig
# variable holds "-".
#    But if inorm already returns a negative number, the "-" in sig is
# not necessary and needs to be erased
#    If the signal is not erased from sig, the resulting float will have
# two "-".
#    To avoid this, the next check is performed.
if [ -n "$(echo "$inorm" | grep "^-")" ]; then
	sig=""
fi

# Normalizing float part
fnorm=$(echo "$float" | sed 's/0*$//')
#    If the number is just a sequence of zeros , the last sed will
# remove all of them.
#    If the float part is also empty, this check solves that by setting
# fnorm=0
if [ -z "$fnorm" ]; then 
	fnorm=0
fi

#    Now that the "-" is memorized according to the integer part, it
# needs to be checked against the float part
#    If the normalized float part is 0, even if the integer part is just
# a "-" signal, the number is zero (-0.0 = 0.0)
#    The next check takes cares ot that.
if [ $fnorm -eq 0 ]; then
	sig=""
fi

res="$sig""$inorm"".""$fnorm"

echo $res
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not float
}

function normalizeInteger() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isInteger $param); then
	return 2
fi

signal=$(echo "$param" | grep "^[+-]" | cut -c 1)

if [ -z "$signal" ]; then
	number=$param
else
	number=$(echo "$param" | sed "s/^$signal//")
fi

# Remove number's leading zeros
res=$(echo "$number" | sed 's/^0*//')
#    If the number is just a sequency of zeros, the last sed will remove
# all of them.
#    If it is also empty, this check solves that by setting res=0 
if [ -z "$res" ]; then
	res=0
fi

#    Place again the "-" before negative numbers. The "+" is supressed
# in positive ones. 
if [ "$signal" == "-" ]; then
	#    If the number is zero but is preceded by "-", the signal is
	# supressed in this check
	if [ $res -ne 0 ]; then 
		res=-$res
	fi
fi

echo $res
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not integer
}

function normalizeNumber() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isNumber $param); then
	return 2
fi

if $(isInteger $param); then
	res=$(normalizeInteger $param)
	echo $res
	return 0
fi

if $(isFloat $param); then
	res=$(normalizeFloat $param)
	echo $res
	return 0
fi

if $(isScientificNotation $param); then
	res=$(normalizeScientificNotation $param)
	echo $res
	return 0
fi

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not a number
}

function normalizeScientificNotation() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isScientificNotation $param); then
	return 2
fi

#    Chosen method: split the number at the "exp" (E/e) symbol:
#    1. The left part is normalized by using "normalizeFloat" or
# "normalizeInteger" 
#    2. The right part is normalized by using "normalizeInteger".

lower=$(echo "$param" | grep "e")
if [ -n "$lower" ]; then
	exp="e"
fi

upper=$(echo "$param" | grep "E")
if [ -n "$upper" ]; then
	exp="E"
fi

left=$(echo "$param" | cut -d "$exp" -f 1)
if $(isInteger $left); then
	lnorm=$(normalizeInteger $left)
fi
if $(isFloat $left); then
	lnorm=$(normalizeFloat $left)
fi

right=$(echo "$param" | cut -d "$exp" -f 2)
rnorm=$(normalizeInteger $right)

res="$lnorm""$exp""$rnorm"
echo $res
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not scientific notation
}