#!/bin/bash

load system.getSystem
load system.getOSXVersion
load system.getArchitecture
load system.getDistroName
load system.getDistroVersion

function getSystemInfo() {
sys=$(getSystem)
case $sys in
	"Darwin")
		name="MacOSX"
		ver="$(getOSXVersion)"
		arch="$(getArchitecture)"
		
		info="$name $ver $arch"
		;;
	"Linux")
		name="$(getDistroName)"
		if [ "$name" != "Other" ]; then
			ver="$(getDistroVersion)"
			arch="$(getArchitecture)"
			
			info="$name $ver $arch"
		else
			info=""
		fi
		;;
	*)
		info=""
		;;
esac

echo "$info"

return 0
}
