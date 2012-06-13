#!/bin/sh

toggle=$(gawk '/^[[:space:]]*forward-socks5[[:space:]]+\/[[:space:]]+127.0.0.1:9050[[:space:]]+\./{commented=1} END {if (commented==1) {print 1} else {print 0}}' </etc/privoxy/config)
case "${toggle}" in
	0 ) sudo sed -i 's/^#\( *forward-socks5 *\/ *127.0.0.1:9050 \{1,\}\.\)/\1/' /etc/privoxy/config;;
	1 ) sudo sed -i 's/^\( *forward-socks5 *\/ *127.0.0.1:9050 \{1,\}\.\)/#\1/' /etc/privoxy/config;;
esac
vimprobable2 http://check.torproject.org/ &

exit 0
