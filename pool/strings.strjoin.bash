#!/bin/bash

load lists.sequence

function strjoin() {
if [ $# -lt 1 ]; then
	return 1
fi

str=""
for i in $(sequence "1-$#"); do
	str="$str$1"
	shift
done

echo "$(tr -d "\'" <<< "$str")"
# NOTE: The use of "tr -d" removes the "'" char from the output string.
#    It happens when passing the output of another function as argument         
# containing single quotes.
#    It's unclear the reason for this behavior.
#    If you try:
#       strjoin $(strsplit "abcd" "")
#  it would output "'a''b''c''d'" without this workaround, instead of "abcd".
#    strsplit function returns characters enclosured by single quotes.
#    But, hey! If you know the reason and/or the proper fix, and if you would   
# like to help, please keep in contact.

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
