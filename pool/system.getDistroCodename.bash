#!/bin/bash

load system.isLinux

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
