#!/bin/bash

# Required Libraries
. Lists.bash
# ---

function ftpRetrieve {
if [ $# -ne 6 ]; then
	return 4
fi

ipaddr=$1
rpath=$2
fn=$3
user=$4
pwd=$5
lpath=$6

if [ ! -e $lpath ]; then
	mkdir -p $lpath
fi

tries=3
timeout=20

if [ ! -e "$lpath/$fn" ]; then
	cd $lpath
	wget -t $tries -T $timeout --ftp-user=$user --ftp-password=$pwd "ftp://$ipaddr$rpath/$fn" &> /dev/null
	
	if [ -e "$lpath/$fn" ]; then
		size=$(ls -l "$lpath/$fn" | awk '{print $5}')
		
		if [ $size -gt 0 ]; then
			cd $HOME
			return 0
		else
			rm "$lpath/$fn"
			
			cd $HOME
			return 2
		fi
	else
		cd $HOME
		return 1
	fi
else
	return 3
fi

# Return codes
# 0 - Download OK
# 1 - Download ERROR
# 2 - Download Size is ZERO
# 3 - Download SKIPPED
# 4 - WRONG parameters
}

function ftpSend {
if [ $# -ne 6 ]; then
	return 4
fi

lpath=$1
fn=$2
ipaddr=$3
rpath=$4
user=$5
pwd=$6

chk=$(listFtpFolder $ipaddr $rpath $user $pwd)
if $(hasItem "$fn" "$chk"); then
	return 3
fi

output=$(ftp -inv $ipaddr 2>&1 << END
user $user $pwd
binary
cd $rpath
lcd $lpath
put $fn
bye
END
)

if [ -n "$(echo $output | grep "$rpath: No such file or directory.")" ]; then
#if [ -n "$(echo $output | grep "550 $rpath: No such file or directory.")" ]; then
#if [ -n "$(echo $output | grep "550 Failed to change directory.")" ]; then
	return 1
fi

if [ -n "$(echo $output | grep "local: $fn: No such file or directory.")" ]; then
	return 2
fi

return 0

# Return codes
# 0 - Send OK
# 1 - Send ERROR: Remote directory does not exist
# 2 - Send ERROR: Local file does not exist
# 3 - Send SKIPPED
# 4 - WRONG parameters
}

function httpRetrieve {
if [ $# -ne 3 ]; then
	return 4
fi

ipaddr=$1
rpath=$2
fn=$3
lpath=$4

tries=3
timeout=20

if [ ! -e "$lpath/$fn" ]; then
	cd $lpath
	wget -t $tries -T $timeout "http://$ipaddr$rpath/$fn" &> /dev/null
	
	if [ -e "$lpath/$fn" ]; then
		size=$(ls -l "$lpath/$fn" | awk '{print $5}')
		
		if [ $size -gt 0 ]; then
			cd $HOME
			return 0
		else
			rm "$lpath/$fn"
			
			cd $HOME
			return 2
		fi
	else
		cd $HOME
		return 1
	fi
else
	return 3
fi

# Return codes
# 0 - Download OK
# 1 - Download ERROR
# 2 - Download Size is ZERO
# 3 - Download SKIPPED
# 4 - WRONG parameters
}

function isFTPServerOK {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

ipaddr=$1

output=$(ftp -inv $ipaddr 2>&1 << END
bye
END
)

if [ -n "$(echo $output | grep 'ftp: connect: Connection timed out')" ]; then
	echo false
	return 1
fi

if [ -n "$(echo $output | grep '421 Service not available.')" ]; then
	echo false
	return 1
fi

echo true
return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function isPingOK {
if [ $# -ne 1 ]; then
	echo false
	return 1
fi

ipaddr=$1

count=10
timeout=5
packets=$(ping -c $count -W $timeout $ipaddr | grep "packets" | awk '{print $1}')
if [ -z "$packets" ]; then
	echo false
	return 1
fi

health=$(($(($packets * 100)) / $count))

limit=80
if [ $health -ge $limit ]; then
	echo true
else
	echo false
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function listFtpFolder {
if [ $# -ne 4 ]; then
	echo ""
	return 1
fi

ipaddr=$1
rpath=$2
user=$3
pwd=$4

output=$(ftp -in $ipaddr 2>&1 << END
user $user $pwd
cd $rpath
ls
bye
END
)

if [ -z "$(echo $output | grep "$rpath: No such file or directory.")" ]; then
#if [ -z "$(echo $output | grep "550 $rpath: No such file or directory.")" ]; then
#if [ -z "$(echo "$output" | grep "Failed to change directory.")" ]; then
#if [ -z "$(echo "$output" | grep "550 Failed to change directory.")" ]; then
	files=""
	c=0
	for i in $output; do
		c=$(($c + 1))
		if [ $(($c % 9)) -eq 0 ]; then
			files="$files $i"
		fi
	done
	
	echo "$files"
else
	echo ""
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}

function listLocalFolder {
if [ $# -ne 1 ]; then
	echo ""
	return 1
fi

lpath=$1

if [ -e $lpath ]; then
	output=$(ls $lpath)
	echo "$output"
else
	echo ""
fi

return 0

# Return codes
# 0 - OK
# 1 - Not enough parameters
}
