#!/bin/bash

load numbers.isFloat
load numbers.normalizeInteger

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
