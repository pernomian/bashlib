#!/bin/bash

load numbers.isNumber
load numbers.isInteger
load numbers.normalizeInteger
load numbers.isFloat
load numbers.normalizeFloat
load numbers.isScientificNotation
load numbers.normalizeScientificNotation

function normalizeNumber() {
if [ $# -ne 1 ]; then
	return 1
fi

param=$1
if ! $(isNumber $param); then
	return 2
fi

if $(isInteger $param); then
	res=$(normalizeInteger $param)
	echo $res
	return 0
fi

if $(isFloat $param); then
	res=$(normalizeFloat $param)
	echo $res
	return 0
fi

if $(isScientificNotation $param); then
	res=$(normalizeScientificNotation $param)
	echo $res
	return 0
fi

# Return codes
# 0 - OK
# 1 - Not enough parameters
# 2 - Input is not a number
}
