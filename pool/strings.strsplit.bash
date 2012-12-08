#!/bin/bash

load lists.sequence
load strings.strlen

function strsplit() {
if [ $# -ne 2 ]; then
	return 1
fi

str="$1"
char="$2"

len=$(strlen "$str")

chars=()

nsplit=$(awk "BEGIN { FS=\"$char\" }; { print NF }" <<< "$str")
for i in $(sequence "1-$nsplit"); do
	chars[$(($i - 1))]="'""$(awk "BEGIN { FS=\"$char\" }; { print \$$i }" <<< "$str")""'"
done

echo "${chars[*]}"

return 0

# Return codes
# 0 - OK
# 1 - Not enough arguments
# 2 - Empty string
}
