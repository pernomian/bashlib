#!/bin/bash

# Required Libraries
. Lists.bash
# ---

echo "* Function: addAt"
INlist="a b c d e f"
echo "    Input list  : $INlist"
pos=4
echo "    Position    : $pos"
item="x"
echo "    Item        : $item"
OUTlist=$(addAt $pos "$item" "$INlist")
echo "    Output list : $OUTlist"

echo "* Function: filterList"
INlist="a.txt b.txt c.pdf d.pdf e.odt f.odt"
echo "    Input list  : $INlist"
criteria=".txt"
echo "    Criteria    : $criteria"
OUTlist=$(filterList ".txt" "$INlist")
echo "    Output list : $OUTlist"

echo "* Function: hasItem"
INlist="a.txt b.txt c.pdf d.pdf e.odt f.odt"
echo "    Input list  : $INlist"
item="f.odt"
echo "    Item        : $item"
res=$(hasItem "$item" "$INlist")
echo "    Result      : $res"
item="a.pdf"
echo "    Item        : $item"
res=$(hasItem "$item" "$INlist")
echo "    Result      : $res"

echo "* Function: isEmptyList"
INlist="a.txt b.txt c.pdf d.pdf e.odt f.odt"
echo "    Input list  : $INlist"
res=$(isEmptyList "$INlist")
echo "    Result : $res"
INlist=""
echo "    Input list  : $INlist"
res=$(isEmptyList "$INlist")
echo "    Result : $res"

echo "* Function: itemAt"
INlist="1 2 3 4 5 6 7 8 9 0"
echo "    Input list  : $INlist"
pos=5
echo "    Position    : $pos"
item=$(itemAt $pos "$INlist")
echo "    Item        : $item"

echo "* Function: sizeOfList"
INlist="q w e r t y"
echo "    Input list  : $INlist"
size=$(sizeOfList "$INlist")
echo "    Size        : $size"
INlist=""
echo "    Input list  : $INlist"
size=$(sizeOfList "$INlist")
echo "    Size        : $size"

exit 0
