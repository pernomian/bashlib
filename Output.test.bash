#!/bin/bash

# Required Libraries
. Output.bash
# ---

echo "* Function: addLeadingZeros"
number=123
echo "    Number : $number"
width=5
echo "    Width  : $width"
res=$(addLeadingZeros $width $number)
echo "    Result : $res"

exit 0
