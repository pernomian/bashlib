#!/bin/bash

load network.isDomain
load network.isIP
load system.isPath

function isFTPDirectory() {
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
# 530 - Not logged in
# ftp: connect: - Connection "timed out | refused"

output=$(mktemp)

ftp -inv $addr &> $output << END
user $user $pwd
binary
passive
cd $rdir
bye
END

if [ -n "$(cat $output | grep "^ftp: connect:")" -o \
     -n "$(cat $output | grep "^530")" ]; then
     rm -f $output &> /dev/null
     return 3
fi

if [ -n "$(cat $output | grep "^250")" ]; then
	echo true
else
	echo false
fi

rm -f $output &> /dev/null

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
# 3 - FTP error, wrong given arguments
}
