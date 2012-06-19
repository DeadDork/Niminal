#!/bin/bash

# This script makes it easy to create a Windows terminal that's well-fitted to the local machine's screen, as well as manage mulitiple RDP connection templates.

# Various RDP settings that are "hard-wired" in the script.
geo="\"$(xrandr --current | gawk '(NR==1){match($0, /current ([0-9]*) x ([0-9]*)/, A); print A[1] "x" A[2] - 5}')\""

# Making sure this file exists.
if [ ! -e ~/.rdesktop_connections_list ]; then
	touch ~/.rdesktop_connections_list
fi

# Connections prompt user menu.
PS3='Establish a new RDP connection or use an established connection?'
select connect_prompt in 'New connection' 'Established connection'; do
	case "${connect_prompt}" in
		'New connection' )
			read -p 'Host address? ' address
			read -p 'Host port (if any)? ' port
			read -p 'User name? ' user
			read -p 'Domain? ' domain
			PS3='Add the new connection to the list of established connections?'
			select add_connect_prompt in 'Yes' 'No'; do
				case "${add_connect_prompt}" in
					'Yes' )
						read -p 'Name of this connection? ' connect_name
						awk 'BEGIN {FS="|"} {print $1}' <~/.rdesktop_connections_list | grep -q -i "${connect_name}" 
						while [ $? = 0 ]; do
							read -p 'Name already used. Name of this connection? ' connect_name
							grep -q -i "${connect_name}" ~/.rdesktop_connections_list
						done
						echo "${connect_name}|${address}|${port}|${domain}|${user}" >> "${HOME}"/.rdesktop_connections_list
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
			PS3='Pick a connection'
			select est_connect in $(awk 'BEGIN {FS="|"} {printf "%s ", $1}' <~/.rdesktop_connections_list); do
				awk 'BEGIN {FS="|"} {print $1}' <~/.rdesktop_connections_list | grep -q -i "${est_connect}" 
				if [ ! $? = 0 ]; then
					echo 'Bad entry. Try again.'
				else
					eval "$(awk 'BEGIN {FS="|"} ($1=="'${est_connect}'"){printf "address=\"%s\"; port=\"%s\"; domain=\"%s\"; user=\"%s\"", $2, $3, $4, $5}' <~/.rdesktop_connections_list)"
					break
				fi
			done
			break
			;;
		* )
			echo 'Bad entry. Try again.'
			;;
	esac
done

if [ -n "${address}" -a -n "${domain}" -a -n "${user}" -a -n "${geo}" ]; then
	PS3='Connection strength?'
	select connect_strength in 'Modem' 'Broadband' 'LAN'; do
		case "${connect_strength}" in
			'Modem' )
				experience='m'
				break
				;;
			'Broadband' )
				experience='b'
				break
				;;
			'LAN' )
				experience='l'
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
	PS3='Mount a drive (e.g. USB -- not to be confused with samba, which is generally a better option for a file sharing servers)?'
	select drive in 'Yes' 'No'; do
		case "${drive}" in
			'Yes' )
				while [ ! -n "${share_name}" -a -n "${mount_location}" ]; do
					read -p 'Enter the share name (cannot be blank): ' share_name
					read -p 'Enter the mount location (cannot be blank): ' mount_location
					device="-r disk:${share_name}=${mount_location}"
				done
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
	if [ -n "${port}" ]; then
		eval "rdesktop -u ${user} -d ${domain} -g ${geo} -x ${experience} ${bitmap_caching} ${device} ${address}:${port}"
	else
		eval "rdesktop -u ${user} -d ${domain} -g ${geo} -x ${experience} ${bitmap_caching} ${device} ${address}"
	fi
fi
