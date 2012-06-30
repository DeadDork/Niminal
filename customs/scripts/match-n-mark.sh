#!/bin/sh

# Usage:

#	./match-n-mark.sh MATCH_FIELD MATCH_PREFIX SOURCE_MATCH_FILE TARGET_MATCH_FILE

# That is, if you want to mark with the prefix '*' all entries from file B that, in their second field, have a match in file A, then enter:

#	./match-n-mark.sh '$2' '*' A B

# This will output all lines from file B, and those lines that have in the second field a match from file A will be marked with '*' at the start of the output row.

##########BEGIN CODE##########

# Makes sure that all of the variables have been entered.
test -z "${1}" -o -z "${2}" -o -z "${3}" -o -z "${4}" && echo "Make sure to enter all variables." && exit 1

# Match script.
awk '{
	"grep -i -q -F -e \"" '"${1}"' "\" '${3}'; echo $?" | getline match_line;
	close("grep -i -q -F -e \"" '"${1}"' "\" '${3}'; echo $?");
	if (match_line == 0) {
		print "'"${2}"'" $0;
	} else {
		print $0;
	}
}' < ${4}
exit 0
