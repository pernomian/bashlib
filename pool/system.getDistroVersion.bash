#!/bin/bash

load system.isLinux

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
