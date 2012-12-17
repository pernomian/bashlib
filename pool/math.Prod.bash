#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function Prod() {
if [ $# -ne 1 ]; then
	return 1
fi

list=($1)

valid=()
v=0
for i in ${list[*]}; do
	if $(isInteger $i) || $(isFloat $i); then
		valid[v]=$i
		v=$(($v + 1))
	fi
done

if [ $v -lt 1 ]; then
	return 2
fi

c=0
for i in ${valid[*]}; do
	if [ $c -eq 0 ]; then
		ans=${valid[0]}
	else
		ans=$(bc -l <<< "scale=20; $ans * $i")
	fi
	
	c=$(($c + 1))
done

awk '{ printf("%.16f\n", $1) }' <<< "$ans"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
