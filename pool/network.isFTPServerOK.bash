#!/bin/bash

load network.isIP

function isFTPServerOK() {
if [ $# -ne 1 ]; then
	return 1
fi

ip="$1"
if ! $(isIP "$ip"); then
	return 2
fi

output=$(mktemp)
ftp -inv $ip &> $output << END
END

# FTP Codes
# 220 - "FTP Server banner/welcome msg"
if [ -n "$(cat $output | grep "^220")" ]; then
	echo true
else
	echo false
fi

rm -f $output &> /dev/null

return 0 

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid IP
}

