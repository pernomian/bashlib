#!/bin/bash

load numbers.isInteger

function sequence() {
if [ $# -ne 1 ]; then
	return 1
fi

lexp=$1
if [ -z "$lexp" ]; then
	return 2
fi

frag=()
if [ -z "$(echo "$lexp" | grep ";")" ]; then
	frag[0]="$lexp"
else
	c=0
	while true; do
		now=$(echo "$lexp" | cut -d ";" -f $(($c + 1)))
		if [ "$now" == "" ]; then
			break
		fi
		
		frag[$c]="$now"
		c=$(($c + 1))
	done
fi

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
		
		if [ $n1 -gt $n2 ]; then
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
