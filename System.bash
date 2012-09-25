#!/bin/bash

# Required libraries
# ---

# Initialization
# ---

function isDarwin() {
if [ "$(getSystem)" == "Darwin" ]; then
	echo true
else
	echo false
fi

return 0
}

function isLinux() {
if [ "$(getSystem)" == "Linux" ]; then
	echo true
else
	echo false
fi

return 0
}

function isSupportedOS() {
if $(isDarwin) || $(isLinux); then
	echo true
else
	echo false
fi

return 0
}

function getArchitecture() {
if $(isSupportedOS); then
	echo "$(uname -m)"
else
	echo ""
	return 1
fi

return 0
}

function getOSXVersion() {
if $(isDarwin); then
	if (type -P sw_vers &> /dev/null); then
		sw_vers -productVersion
	else
		echo ""
	fi
else
	echo ""
fi

return 0
}

function getDistroName() {
if $(isLinux); then
	if (type -P lsb_release &> /dev/null); then
		lsb_release -i | awk {'print $3'}
	else
		echo "Other"
		return 2
	fi
else
	echo ""
	return 1
fi

return 0
}

function getDistroVersion() {
if $(isLinux); then
	if (type -P lsb_release &> /dev/null); then
		lsb_release -d | awk {'print $3'}
	else
		echo ""
		return 2
	fi
else
	echo ""
	return 1
fi

return 0
}

function getDistroCodename() {
if $(isLinux); then
	if (type -P lsb_release &> /dev/null); then
		lsb_release -c | awk {'print $2'}
	else
		echo ""
		return 2
	fi
else
	echo ""
	return 1
fi

return 0
}

function getSystem() {
echo "$(uname -s)"

return 0
}

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
