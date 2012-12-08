#! /bin/bash

load numbers.isInteger
load strings.strlen
load strings.substring

function strrep() {
if [ $# -ne 4 ]; then
	return 1
fi

substr1="$1"
substr2="$2"
max_rep="$3"
str="$4"

len_str=$(strlen "$str")
if [ $len_str -eq 0 ]; then
	return 2
fi

len_substr1=$(strlen "$substr1")
if [ $len_substr1 -gt $len_str ]; then
	return 2
fi

if ! $(isInteger "$max_rep"); then
	return 2
fi
if [ $max_rep -lt 0 ]; then
	return 2
fi

p2=0
c=0
nrep=0
newstr="$str"
while [ $p2 -lt $len_str ]; do
	p1=$(($c + 1))
	p2=$(($p1 + $len_substr1 - 1))
	test_sub="$(substring $p1 $p2 "$str")"
	if [ "$test_sub" == "$substr1" ]; then
		prev_p1=1
		prev_p2=$(($p1 - 1))
		next_p1=$(($p2 + 1))
		next_p2=$len_str
		
		if [ $prev_p2 -lt $prev_p1 ]; then
			prev_sub=""
		else
			prev_sub="$(substring $prev_p1 $prev_p2 "$newstr")"
		fi
		
		if [ $next_p1 -gt $next_p2 ]; then
			next_sub=""
		else
			next_sub="$(substring $next_p1 $next_p2 "$newstr")"
		fi
		
		newstr="$prev_sub""$substr2""$next_sub"
		
		nrep=$(($nrep + 1))
	fi
	
	if [ $max_rep -ne 0 -a $nrep -eq $max_rep ]; then
		break
	fi
	
	c=$(($c + 1))
done

echo "$newstr"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
