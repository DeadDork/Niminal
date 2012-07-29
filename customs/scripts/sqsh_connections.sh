#!/bin/bash

# Eases connecting to established Sybase or Microsoft SQL Server DBMS servers.

# Variables
# This points to the sqsh connection settings file.
connections_file="${HOME}/.config/scripts/sqsh_connections.settings"

# Functions
# This function creates a new connection.
new_connection () {
	# Get the interface name.
	clear
	while [ -z "${interface}" ]; do
		read -p 'Interface PATH & NAME (e.g. "/home/work/local/etc/freetds.conf")? ' interface
	done

	# Get the server name.
	clear
	PS3='Server name?'
	IFS="	"
	select server in $(awk '/^\[[^\]]+\]/{printf "%s\t", gensub(/^\[([^\]]+)\].*/, "\\1", 1)}' < "${interface}"); do 
		grep -q '^\['"${server}"'\]' "${interface}"
		if [ $? -eq 0 ]; then
			break
		else
			# Error trap.
			echo 'Bad SERVER selection. Try again.'
		fi
	done
	unset IFS

	# Get the user name.
	clear
	read -p 'USER name (e.g "domain\tester". N.B. If there is a "\", be sure to escape it, i.e. "domain\\tester")? ' user

	# Adds the connection to the connections file.
	echo -e "${interface} ${server} ${user}" >> "${connections_file}"
}

# Makes sure that a scripts directory exists.
test ! -d ~/.config/scripts/ && mkdir -p ~/.config/scripts

# Makes sure that a connections file exists & that it is not empty.
if [ ! -e "${connections_file}" ]; then
	touch "${connections_file}"
	empty=1
else
	empty=0
fi

# If no connections exist, the user is prompted for connection information. If connections exist, then the user is prompted whether to use an established connection or to create a new one.
if [ $empty -eq 1 ]; then
	# Create a new connection because none exist yet.
	new_connection
elif [ $empty -eq 0 ]; then
	# Select whether to create a new connection setting or use an established one.
	PS3='Choose to create a new connection setting or use an established one.'
	select setting in 'New connection' 'Established connection'; do
		case "${setting}" in
			# If a NEW CONNECTION is desired, then the necessary connection settings are collected.
			'New connection' )
				new_connection
				break
				;;
	
			# If an ESTABLISHED CONNECTION is desired, then the necessary connection settings are retrieved from the settings file.
			'Established connection' )
				clear
				PS3='Choose which established connection to use.'
				IFS='	'
				select connection in $(awk '{printf "%s\t", $0}' < "${connections_file}"); do
					grep -q -F "${connection}" "${connections_file}"
					if [ $? -eq 0 ]; then
						interface="$(echo "${connection}" | awk '{printf "%s", $1}')"
						server="$(echo "${connection}" | awk '{printf "%s", $2}')"
						user="$(echo "${connection}" | awk '{printf "%s", $3}')"
						break
					else
						# Error trap.
						echo 'Bad CONNECTION selection. Try again.'
					fi
				done
				unset IFS
				break
				;;

			# Error trap.
			* )
				echo 'Bad SETTING selection. Try again.'
				;;
		esac
	done
fi

# Opens sqsh using the selected connection settings.
clear
sqsh -I "${interface}" -S "${server}" -U "${user}"

exit 0
