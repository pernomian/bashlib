#!/bin/bash

load strings.isCharacter
load strings.isEmptyString
load strings.strlen
load strings.substring

function charrep() {
if [ $# -ne 3 ]; then
	return 1
fi

pos="$1"
char="$2"
str="$3"

len_str=$(strlen "$str")

if $(isEmptyString "$str"); then
	return 2
fi

if ! $(isCharacter "$char"); then
	return 2
fi

if [ $pos -lt 1 -o $pos -gt $len_str ]; then
	return 2
fi

p1=1
p2=$(($pos - 1))
n1=$(($pos + 1))
n2=$len_str

if [ $p2 -lt $p1 ]; then
	psub=""
else
	psub=$(substring $p1 $p2 "$str")
fi

if [ $n1 -gt $n2 ]; then
	nsub=""
else
	nsub=$(substring $n1 $n2 "$str")
fi

newstr="$psub""$char""$nsub"

echo "$newstr"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
