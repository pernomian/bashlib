#!/bin/bash

load system.getSystem

function isLinux() {
if [ "$(getSystem)" == "Linux" ]; then
	echo true
else
	echo false
fi

return 0
}
