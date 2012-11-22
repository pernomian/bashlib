#!/bin/bash

load system.isLinux

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
