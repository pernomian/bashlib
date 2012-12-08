#!/bin/bash

BASHLIB_HOME="/path/to/bashlib"

function load() {
if [ $# -ne 1 ]; then
	echo "bashlib: load: argument required."
	return 1
fi

fpath="$BASHLIB_HOME/pool/$1.bash"
if [ ! -f $fpath ]; then
	echo "bashlib: load: \"$1\": module not found."
	return 2
else
	fname=$(awk 'BEGIN {FS="."} {print $NF}' <<< "$1")
	
	#rc=$($mname &> /dev/null; echo $?)
	#if [ $rc -eq 127 ]; then
	#	. $mpath
	#	return 0
	#else
	#	echo "bashlib: load: \"$1\": module already loaded."
	#	return 3
	#fi
	
	if [ "$(type -t $fname)" != "function" ]; then
		. $fpath
		return 0
	else
		return 3
	fi
	
fi
}

function unload() {
for f in $BASHLIB_HOME/pool/*.bash; do
	fname=$(cut -d "." -f 2 <<< "$(basename $f .bash)")
	
	if [ "$(type -t $fname)" == "function" ]; then
		unset -f $fname
	fi	
done

unset -f load
unset -f unload

return 0
}
