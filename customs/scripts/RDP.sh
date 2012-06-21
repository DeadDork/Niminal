#!/bin/bash

# This script makes it easy to create a Windows terminal that's well-fitted to the local machine's screen, as well as connect to any previously created connections.

# Various RDP settings that are "hard-wired" in the script.
geometry="-g $(xrandr --current | gawk '(NR==1){match($0, /current ([0-9]*) x ([0-9]*)/, A); print A[1] "x" A[2] - 5}')"

# Making sure this file exists.
if [ ! -e ~/.rdesktop_connections_list ]; then
	touch ~/.rdesktop_connections_list
fi

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
						echo 'Bad entry. Try again.'
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
						echo 'Bad entry. Try again.'
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
						echo "Bad entry. Try again."
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
			settings="$(echo ${user} ${domain} ${geometry} ${experience} ${bitmap_caching} ${device} ${address}${port} | sed 's/ /_/g')" # Horrible kludge to make the Established Connections select work...
			PS3='Add the new connection to the list of established connections?'
			select add_connect_prompt in 'Yes' 'No'; do
				case "${add_connect_prompt}" in
					'Yes' )
						grep -F -i -q -e "${settings}" ~/.rdesktop_connections_list 
						if [ ! $? = 0 ]; then
							echo "${settings}" >> "${HOME}"/.rdesktop_connections_list
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
			break
			;;
		'Established connection' )
			PS3='Pick a connection.'
			if [ -s ~/.rdesktop_connections_list ]; then
				select est_connect in $(awk '{printf "%s ", $0}' <~/.rdesktop_connections_list); do
					grep -q -e "${est_connect}" ~/.rdesktop_connections_list
					if [ ! $? = 0 ]; then
						echo 'Bad entry. Try again.'
					else
						settings="${est_connect}"
						break
					fi
				done
				break
			else
				echo -e "\nThere are no established connections. Execute the script again to create one.\n"
				exit 1
			fi
			;;
		* )
			echo 'Bad entry. Try again.'
			;;
	esac
done

rdesktop $(echo ${settings} | sed 's/_/ /g')

exit 0
