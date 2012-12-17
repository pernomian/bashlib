#!/bin/bash

function e() {
if [ $# -ne 0 ]; then
	return 1
fi

echo $(bc -l <<< "scale=20; e(1)")

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
}
