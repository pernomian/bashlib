#!/bin/bash

load system.isSupportedOS

function getArchitecture() {
if $(isSupportedOS); then
	echo "$(uname -m)"
else
	echo ""
	return 1
fi

return 0
}
