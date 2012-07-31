#!/bin/bash

# Required Libraries
# ---

function filterList {
if [ $# -ne 2 ]; then
	return 1
fi

criteria=$1
inlist=$2

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
}

function hasItem {
if [ $# -ne 2 ]; then
	return 1
fi

item=$1
list=$2

if [ -n "$(echo $list | grep "$item")" ]; then
	echo true
else
	echo false
fi
}

function isEmptyList {
if [ $# -ne 1 ]; then
	echo true
	return 1
fi

list=$1

if [ $(sizeOfList "$list") -eq 0 ]; then
	echo true
else
	echo false
fi

return 0
}

function itemAt {
if [ $# -ne 2 ]; then
	echo ""
	return 1
fi

pos=$1
list=$2

c=0
for item in $list; do
	c=$(($c + 1))
	if [ $c -eq $pos ]; then
		echo "$item"
		break
	fi
done

return 0
}

function removeItemAt {
if [ $# -ne 2 ]; then
	return 1
fi

pos=$1
list=$2

size=$(sizeOfList "$list")

if [ $pos -lt 1 -o $pos -gt $size ]; then
	echo "$list"
	return 0
fi

res=""
c=0
for i in $(seq 1 1 $size); do
	if [ $i -eq $pos ]; then
		res="$res"
	else
		if [ $c -ne 0 ]; then
			res="$res $(itemAt $i "$list")"
		else
			res="$(itemAt $i "$list")"
		fi
		
		c=$(($c + 1))
	fi
done

echo "$res"
return 0
}

function sizeOfList {
if [ $# -ne 1 ]; then
	return 1
fi

list=$1

c=0
for i in $list; do
	c=$(($c + 1))
done

echo $c
return 0
}

function whatsNew {
if [ $# -ne 2 ]; then
	return 1
fi

old=$1
new=$2

res=$(diff -c $old $new | grep '^+' | cut -d " " -f 2)

echo "$res"
return 0
}
