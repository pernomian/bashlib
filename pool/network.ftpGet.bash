#!/bin/bash

load network.isIP
load system.isPath
load system.isDirectory
load system.isWritable

function ftpGet() {
if [ $# -ne 6 ]; then
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
if ! $(isIP "$addr"); then
	return 2
fi

rdir="$4"
if ! $(isPath "$rdir"); then
	return 2
fi

fn="$5"
if [ -z "$fn" ]; then
	return 2
fi

ldir="$6"
if ! $(isPath "$ldir"); then
	return 2
fi
if ! $(isDirectory "$ldir"); then
	return 2
fi
if ! $(isWritable "$ldir"); then
	return 2
fi

if [ -f $ldir/$fn ]; then
	return 3
fi

# FTP codes
# 226 - Transfer complete
# 530 - Not logged in
# 550 - No such file or directory
# local: <FILE/DIR>: - No such file or directory

output=$(mktemp)

ftp -inv $addr &> $output << END
user $user $pwd
binary
passive
lcd $ldir
cd $rdir
get $fn
bye
END

if [ -n "$(cat $output | grep "^530")" -o \
     -n "$(cat $output | grep "^550")" -o \
     -n "$(cat $output | grep "^local: $ldir: No such file or directory")" ]; 
then
	rm -f $output &> /dev/null
	return 4
fi

if [ -z "$(cat $output | grep "^226")" ]; then
	rm -f $output &> /dev/null
	return 5
fi

rm -f $output &> /dev/null

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
# 3 - File already exists, skipped
# 4 - FTP error, wrong given arguments
# 5 - File not retrieved
}
