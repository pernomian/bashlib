#!/bin/bash

load system.isDarwin
load system.isLinux

function isSupportedOS() {
if $(isDarwin) || $(isLinux); then
	echo true
else
	echo false
fi

return 0
}
