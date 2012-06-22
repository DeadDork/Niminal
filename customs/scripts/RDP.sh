#!/bin/bash

# This script makes it easy to create a Windows terminal that's well-fitted to the local machine's screen, as well as connect to any previously created connections.

# Because some of the expanded variables have individual WORDS that have space elements, IFS has to be set to 

# This file stores all of the RDP connection settings.
settings_store="${HOME}/.rdesktop_connections_list"

# Make sure the file exists.
if [ ! -e $settings_store ]; then
	touch $settings_store
fi

# Geometry values can't be saved, as a change in monitors leads to problems, etc.
geometry="-g $(xrandr --current | gawk '(NR==1){match($0, /current ([0-9]*) x ([0-9]*)/, A); print A[1] "x" A[2] - 5}')"

# Connections prompt user menu.
PS3='Establish a new RDP connection or use previously created connection settings?'
select connect_prompt in 'New connection' 'Established connection'; do
	case "${connect_prompt}" in
		'New connection' )
			while [ -z "${user}" ]; do
				read -p 'User name? ' user
			done
			user="-u ${user}"
			while [ -z "${domain}" ]; do
				read -p 'Domain? ' domain
			done
			domain="-d ${domain}"
			PS3='Connection strength?'
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
			while [ -z "${address}" ]; do
				read -p 'Host address? ' address
			done
			read -p 'Host port (if any)? ' port
			if [ -n "${port}" ]; then
				port=":${port}"
			fi
			settings="${user} ${domain} ${experience} ${bitmap_caching} ${device} ${address}${port}" # Do NOT include geometry!
			PS3='Add the new connection to the list of established connections?'
			select add_connect_prompt in 'Yes' 'No'; do
				case "${add_connect_prompt}" in
					'Yes' )
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
		'Established connection' )
			if [ -s $settings_store ]; then
				PS3='Pick a connection.'
				select est_connect in "$(cat $settings_store)"; do
					grep -F -q -e "${est_connect}" $settings_store
					if [ $? = 0 -a -n "${est_connect}" ]; then
						settings="${est_connect}"
						break
					else
						echo 'Bad connection for list choice. Try again.'
					fi
				done
			else
				echo -e "\nThere are no established connections. Execute the script again to create one.\n"
				exit 1
			fi
			break
			;;
		* )
			echo 'Either choose to create new connection or use an established one. Try again.'
			;;
	esac
done

echo "${geometry} ${settings}"
#rdesktop "${geometry} ${settings}"

exit 0
