#!/bin/bash
read -p 'Local host? ' localhost
read -p 'Local port? ' localport
read -p 'Remote host? ' remotehost
read -p 'Remote port? ' remoteport
echo -e '#!/bin/sh\nread -p "Enter '"${remotehost}'s"' IP Address: " ip\n# This port is unique to '"${remotehost}"' in order to obviate ssh headaches.\nssh -R '"${remoteport}:localhost:22 ${remotehost}@"'"${ip}"' > "r-ssh_to_${remotehost}"
echo -e '#!/bin/sh\nread -p "Enter the file name (with its full file path) that you want to scp: " source\nread -p "Enter the destination directory (with its full file path): " destination\n# Uses '"${localhost}'s"' unique port.\nscp -r -P '"${localport} ${remotehost}"'@localhost:"${source}" "${destination}"' > "scp_${remotehost}_${remotehost}2${localhost}.sh"
echo -e '#!/bin/sh\nread -p "Enter the file name (with its full file path) that you want to scp: " source\nread -p "Enter the destination directory (with its full file path): " destination\n# Uses '"${localhost}'s"' unique port.\nscp -r -P '"${localport}"' "${source}" '"${remotehost}"'@localhost:"${destination}"' > "scp_${remotehost}_${localhost}2${remotehost}.sh"
chmod 755 "r-ssh_to_${remotehost}"
chmod 755 "scp_${remotehost}_${remotehost}2${localhost}.sh"
chmod 755 "scp_${remotehost}_${localhost}2${remotehost}.sh"
