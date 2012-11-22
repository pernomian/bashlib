#!/bin/bash

load system.getSystem

function isDarwin() {
if [ "$(getSystem)" == "Darwin" ]; then
	echo true
else
	echo false
fi

return 0
}
