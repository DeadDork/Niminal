#!/bin/bash

# This script makes it easy to create a Windows terminal that's well-fitted to the local machine's screen, as well as connect to any previously created connections.

# This file stores all of the RDP connection settings.
settings_store="${HOME}/.rdesktop_connections_list"

# Make sure the file exists.
if [ ! -e $settings_store ]; then
	touch $settings_store
fi

# Geometry values can't be saved, but have to be determined every time this script is called, as a change in monitors leads to problems, etc.
geometry="-g $(xrandr --current | gawk '(NR==1){match($0, /current ([0-9]*) x ([0-9]*)/, A); print A[1] "x" A[2] - 5}')"

# Top-level of the menu: select NEW CONNECTION, OLD CONNECTION, ERROR.
PS3='Establish a new RDP connection or use previously created connection settings?'
clear
select connect_prompt in 'New connection' 'Established connection'; do
	case "${connect_prompt}" in
		# If NEW CONNECTION, then collect all of the setting data.
		'New connection' )
			clear
			while [ -z "${user}" ]; do
				read -p 'User name? ' user
			done
			user="-u ${user}"
			clear
			while [ -z "${domain}" ]; do
				read -p 'Domain? ' domain
			done
			domain="-d ${domain}"
			PS3='Connection strength?'
			clear
			select connect_strength in 'Modem' 'Broadband' 'LAN'; do
				case "${connect_strength}" in
					'Modem' )
						experience='-x m'
						break
						;;
					'Broadband' )
						experience='-x b'
						break
						;;
					'LAN' )
						experience='-x l'
						break
						;;
					* )
						echo 'Bad connection strength choice. Try again.'
						;;
				esac
			done
			PS3='Bitmap caching?'
			clear
			select bmp_cache in 'Yes' 'No'; do
				case "${bmp_cache}" in
					'Yes' )
						bitmap_caching='-P'
						break
						;;
					'No' )
						bitmap_caching=''
						break
						;;
					* )
						echo 'Bad bitmap caching choice. Try again.'
						;;
				esac
			done
			PS3='Mount a drive (e.g. USB. N.B. if you want to share a drive, use samba instead)?'
			clear
			select drive in 'Yes' 'No'; do
				case "${drive}" in
					'Yes' )
						while [ -z "${share_name}" ]; do
							read -p 'Enter the share name (cannot be blank): ' share_name
						done
						while [ -z "${mount_location}" ]; do
							read -p 'Enter the mount location (cannot be blank): ' mount_location
						done
						device="-r disk:${share_name}=${mount_location}"
						break
						;;
					'No' )
						device=''
						break
						;;
					* )
						echo "Bad mount drive choice. Try again."
						;;
				esac
			done
			clear
			while [ -z "${address}" ]; do
				read -p 'Host address? ' address
			done
			clear
			read -p 'Host port (if any)? ' port
			if [ -n "${port}" ]; then
				port=":${port}"
			fi
			settings="${user} ${domain} ${experience} ${bitmap_caching} ${device} ${address}${port}" # Do NOT include geometry!
			PS3='Add the new connection to the list of established connections?'
			clear
			select add_connect_prompt in 'Yes' 'No'; do
				case "${add_connect_prompt}" in
					'Yes' )
						# It's easier to just have one line in the file, rather than a series of lines that have to be concatenated into one line in the OLD CONNECTIONS case.
						grep -F -i -q -e "${settings}" $settings_store 
						if [ ! $? = 0 ]; then
							if [ -s $settings_store ]; then
								sed -i 's/\(.*\)/\1\t'"${settings}"'/' $settings_store
							else
								echo "${settings}" > $settings_store
							fi
						fi
						break
						;;
					'No' )
						break
						;;
					* )
						echo 'Choice out of bounds for adding the connection to the list. Try again.'
						;;
				esac
			done
			break
			;;
		# If OLD CONNECTION, then select the old connection to connect to.
		'Established connection' )
			clear
			if [ -s $settings_store ]; then
				PS3='Pick a connection.'
				IFS="	" # The expanded WORDS of the established connection have space elements, and accordingly the IFS is temporarily changed to just TAB.
				select est_connect in $(cat $settings_store); do
					unset IFS # Returning IFS to stock setting.
					grep -F -q -e "${est_connect}" $settings_store
					if [ $? = 0 -a -n "${est_connect}" ]; then
						settings="${est_connect}"
						break
					else
						echo 'Bad connection for list choice. Try again.'
					fi
				done
			else
				echo -e "\nThere are no established connections. Execute the script again to create one.\n" # Couldn't find a GOTO-like command in BASH to go to NEW CONNECTION here.
				exit 1
			fi
			break
			;;
		* )
			echo 'Either choose to create new connection or use an established one. Try again.'
			;;
	esac
done

# Open the Windows terminal with the desired settings.
rdesktop ${geometry} ${settings}

exit 0
