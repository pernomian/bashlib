#!/bin/bash

load numbers.isInteger

function Factorial() {
if [ $# -ne 1 ]; then
	return 1
fi

x="$1"
if ! $(isInteger $x); then
	return 2
fi
if [ $x -lt 0 ]; then
	return 2
fi

echo $(bc -l <<< "define f(x) { ans=1; for (i=1; i<=x; i++) { ans=ans*i }; retu\
rn ans }; f($x)")

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Invalid arguments
}
