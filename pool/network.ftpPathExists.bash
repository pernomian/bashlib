#!/bin/bash

load network.isDomain
load network.isIP
load system.isPath

function ftpPathExists() {
if [ $# -ne 4 ]; then
	return 1
fi

user="$1"
if [ -z "$user" ]; then
	user="anonymous"
fi

pwd="$2"
if [ -z "$pwd" -a "$user" == "anonymous" ]; then
	pwd="anonymous"
fi

addr="$3"
if ! $(isIP "$addr") && ! $(isDomain "$addr"); then
	return 2
fi

rpath="$4"
if ! $(isPath "$rpath"); then
	return 2
fi

# FTP codes
# 226 - Transfer complete

output=$(mktemp)

ftp -inv $addr &> $output << END
user $user $pwd
binary
passive
dir $rpath
bye
END

if [ -z "$(cat $output | grep "^226")" ]; then
	rm -f $output &> /dev/null
	return 3
fi

items=$(cat $output | grep "[ld-]\([r-][w-][sx-]\)\{2\}\([r-][w-][tx-]\)\{1\}" | wc -l)

rm -r $output &> /dev/null

if [ $items -gt 0 ]; then
	echo true
else
	echo false
fi

return 0 

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
# 3 - FTP error, couldn't get list
}
