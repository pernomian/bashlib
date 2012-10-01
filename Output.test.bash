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

echo "* Function: gotoxy"
x=5
y=10
echo "    Position : X=$x; Y=$y"
gotoxy $x $y
echo "$?"

gotoxy 30 2
setTextColour "light-red"
echo "Teste"
gotoxy 50 5
setTextColor "none"
setBgColour "red"
echo "Mais teste"

gotoxy 1 1
setTextColor "light-purple"
setBgColour "green"
echo "UBUNTU!"
colorReset

setTextColor "light-red"
setBgColor "brown"
echo "ATENÇÃO!!!"
colourReset

exit 0
