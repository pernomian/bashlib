#!/bin/bash

load system.isDarwin

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
