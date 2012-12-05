#!/bin/bash

load numbers.isFloat
load numbers.isInteger

function abs() {
if [ $# -ne 1 ]; then
	return 1
fi

number=$1
if ! $(isInteger $number) && ! $(isFloat $number); then
	return 2
fi

if [ $(bc <<< "$number < 0") -eq 1 ]; then
	value=$(bc <<< "$number * -1")
else
	value=$number
fi

echo $value

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
