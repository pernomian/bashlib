#!/bin/bash

# Initialization
CONFIRMED='0'
ELEMENTS='0'
SYS=$(uname -s)
# ---

BASH_VER='3'

PROGRAMS[0]='grep'
PROGRAMS[1]='cut'
PROGRAMS[2]='bc'
PROGRAMS[3]='awk'
PROGRAMS[4]='date'
PROGRAMS[5]='sed'
PROGRAMS[6]='uname'
PROGRAMS[7]='ftp'
PROGRAMS[8]='mktemp'
PROGRAMS[9]='wc'
PROGRAMS[10]='tr'

if [ "$SYS" == 'Darwin' -o "$SYS" == 'Linux' ]; then
	for PROGRAM in ${PROGRAMS[@]}; do
		ELEMENTS=$((ELEMENTS+1))
		if ( type -P $PROGRAM &> /dev/null ); then
			CONFIRMED=$((CONFIRMED+1))
			echo "'$PROGRAM'.... OK"
		else
			echo "I need '$PROGRAM' to run"
		fi
	done

	ELEMENTS=$((ELEMENTS+1))
	if [ "$BASH_VERSINFO" -ge "$BASH_VER" ]; then
		CONFIRMED=$((CONFIRMED+1))
		echo "Bash version..... OK"
	else
		echo "Bash...   Failed"
	fi

	if [ "$CONFIRMED" -eq "$ELEMENTS" ]; then
		echo "Passed! You can run bashlib"
	else
		echo "Install deps and run me after this..."
	fi
else
	echo "Your system is not supported"
fi
