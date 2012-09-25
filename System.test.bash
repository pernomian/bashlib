#!/bin/bash

# Required libraries
. System.bash
. Lists.bash
# ---

if $(isDarwin); then
	echo "This is a Mac system"
else
	echo "This is not a Mac system"
fi

if $(isLinux); then
	echo "This is a Linux system"
else
	echo "This is not a Linux system"
fi

if $(isSupportedOS); then
	echo "This is a Supported system"
else
	echo "This is not a Supported system"
fi


getOSXVersion
getDistroName
getDistroVersion
getDistroCodename
getArchitecture

sysinfo=$(getSystemInfo)
echo "$sysinfo"
echo $(addAt 10 "default" "$sysinfo")

exit 0
