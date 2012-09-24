#!/bin/bash

# Required Libraries
. Numbers.bash
# ---

function addAt() {
if [ $# -ne 3 ]; then
	return 1
fi

pos=$1
if ! $(isInteger $pos); then
	return 2
fi
if [ $pos -lt 1 ]; then
	return 2
fi

item="$2"
if [ -z "$item" ]; then
	return 2
fi

list="$3"
size=$(sizeOfList "$list")
if [ $pos -gt $(($size + 1)) ]; then
	return 2
fi

list=($list)
res=()
for i in $(sequence "1-$(($size + 1))"); do
	c=$(($i - 1))
	if [ $i -lt $pos ]; then
		res[$c]=${list[$c]}
	elif [ $i -eq $pos ]; then
		res[$c]="$item"
	else
		res[$c]=${list[$(($c - 1))]}
	fi
done

echo "${res[*]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Position and/or Item
}

function filterList() {
if [ $# -ne 2 ]; then
	return 1
fi

criteria=$1
if [ -z "$criteria" ]; then
	return 2
fi

inlist=$2
if $(isEmptyList "$inlist"); then
	return 2
fi

outlist=""
for i in $inlist; do
	if [ -n "$(echo "$i" | grep "$criteria")" ]; then
		if [ -z "$outlist" ]; then
			outlist="$i"
		else
			outlist="$outlist $i"
		fi
	fi
done

echo "$outlist"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Empty Criteria and/or List
}

function hasItem() {
if [ $# -ne 2 ]; then
	return 1
fi

item="$1"
if [ -z "$item" ]; then
	return 2
fi

list="$2"
if $(isEmptyList "$list"); then
	return 2
fi

if [ -n "$(echo "$list" | grep "$item")" ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Empty Item and/or List
}

function isEmptyList() {
if [ $# -ne 1 ]; then
	return 1
fi

list="$1"

if [ -z "$list" ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function itemAt() {
if [ $# -ne 2 ]; then
	return 1
fi

pos=$1
if ! $(isInteger $pos); then
	return 2
fi
if [ $pos -lt 1 ]; then
	return 2
fi

list=$2
if $(isEmptyList "$list"); then
	return 2
fi

list=($list)

echo "${list[$(($pos - 1))]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Position and/or Empty List
}

function removeAt() {
if [ $# -ne 2 ]; then
	return 1
fi

pos=$1
if ! $(isInteger $pos); then
	return 2
fi
if [ $pos -lt 1 ]; then
	return 2
fi

list="$2"
if $(isEmptyList "$list"); then
	return 2
fi

size=$(sizeOfList "$list")
if [ $pos -gt $size ]; then
	res=($list)
else
	res=($list)
	unset res[$(($pos - 1))]
fi

echo "${res[*]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Invalid Position and/or Empty List
}

function sequence() {
if [ $# -ne 1 ]; then
	return 1
fi

lexp=$1
if [ -z "$lexp" ]; then
	return 2
fi

frag=()
last=""
c=1
while true; do
	now=$(echo "$lexp" | cut -d ";" -f $c)
	if [ "$now" == "" ]; then
		break
	fi
	
	if [ "$now" != "$last" ]; then
		frag[$c]="$now"
		last="$now"
		c=$(($c + 1))
	else
		break
	fi
done

Seq=()
c=0
for f in ${frag[*]}; do
	if [ -n "$(echo "$f" | grep "-")" ]; then
		n1=$(echo "$f" | cut -d "-" -f 1)
		if ! $(isInteger $n1); then
			return 2
		fi
		
		n2=$(echo "$f" | cut -d "-" -f 2)
		if ! $(isInteger $n2); then
			return 2
		fi
		
		if [ $n1 -ge $n2 ]; then
			return 2
		fi
		
		v=$n1
		while [ $v -le $n2 ]; do
			Seq[$c]=$v
			c=$(($c + 1))
			v=$(($v + 1))
		done
	else
		if ! $(isInteger $f); then
			return 2
		fi
		
		Seq[$c]=$f
		c=$(($c + 1))
	fi
done

echo "${Seq[*]}"

return 0


# Return codes
# 0 -OK
# 1 - Not enough parameters
# 2 - Invalid expression
}

function sizeOfList() {
if [ $# -ne 1 ]; then
	return 1
fi

list="$1"

size=$(echo "$list" | awk '{print NF}')

echo "$size"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function whatsNew() {
if [ $# -ne 2 ]; then
	return 1
fi

old="$1"
new="$2"

res=$(diff -c "$old" "$new" | grep '^+' | cut -d " " -f 2)

echo "$res"

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
