#!/bin/bash

# A quickie script to toggle Tor.

change_row=$(awk '/^ *#? *forward-socks5 *\/ *127.0.0.1:9050 +\./{print NR}' </etc/privoxy/config)

clear
if [[ "$(awk 'NR=='$change_row /etc/privoxy/config)" =~ ^\ *\# ]]; then
	tor_status='OFF'
else
	tor_status='ON'
fi
echo "Tor is $tor_status"
PS3='Toggle Tor?'
select toggle in 'Yes' 'No'; do
	case $toggle in
		'Yes' )
			if [ "${tor_status}" == 'OFF' ]; then
				sudo bash -c "sed -i \"$change_row \"'s/^ *#\(.*\)/\1/' /etc/privoxy/config"
				echo "Tor toggled ON."
			elif [ "${tor_status}" == 'ON' ]; then
				sudo bash -c "sed -i \"$change_row \"'s/\(.*\)/#\1/' /etc/privoxy/config"
				echo "Tor toggled OFF."
			fi
			break
			;;
		'No' )
			break
			;;
		* )
			echo 'Bad entry. Try again.'
			;;
	esac
done

exit 0
