#!/bin/bash

function isDomain() {
if [ $# -ne 1 ]; then
	return 1
fi

domain=$(grep -x '\([A-Za-z0-9-]\+\.\)\+[A-Za-z0-9]\+' <<< "$1")
if [ -n "$domain" ]; then
	if [ -z "$(grep '^\-' <<< "$domain")" -a \
         -z "$(grep '\-\.' <<< "$domain")" -a \
         -z "$(grep '\.\-' <<< "$domain")" ]; then
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
# 1 - Not enough arguments
}
