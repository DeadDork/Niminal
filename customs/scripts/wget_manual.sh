#!/bin/bash

# I keep forgetting the wget flags I prefer when downloading things like manuals. Hence this script.

if [[ $# < 2 ]]; then
	echo -e "\nUSAGE:\n\twget_manual.sh PREFIX URL\nEXAMPLE:\n\twget_manual.sh ~/Documents/manuals/ABS http://tldp.org/LDP/abs/html/\n"
	exit 1
fi

wget -r -l 1 -p -k -P "${1}" "${2}"

exit 0
