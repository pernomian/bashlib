#!/bin/bash

load network.isDomain
load network.isIP
load system.isPath

function ftpList() {
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

rdir="$4"
if ! $(isPath "$rdir"); then
	return 2
fi

# FTP codes
# 226 - Transfer complete
# 250 - Directory changed to <DIR>

output=$(mktemp)

ftp -inv $addr &> $output << END
user $user $pwd
binary
passive
cd $rdir
dir
bye
END

if [ -z "$(cat $output | grep "^250")" -o \
     -z "$(cat $output | grep "^226")" ]; then
     rm $output &> /dev/null
     return 3
fi

list=$(cat $output | grep "[ld-]\([r-][w-][sx-]\)\{2\}\([r-][w-][tx-]\)\{1\}" | awk '{ print $9 }')

echo "$list"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
# 3 - FTP error, wrong given arguments 
}
