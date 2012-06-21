#!/bin/sh

# A quickie script to toggle Tor.

grep -q '^ *forward-socks5 *\/ *127.0.0.1:9050 \{1,\}\.' /etc/privoxy/config
if [ $? = 0 ]; then
	sudo sed -i 's/^\( *forward-socks5 *\/ *127.0.0.1:9050 \{1,\}\.\)/#\1/' /etc/privoxy/config
	echo "Tor OFF"
else
	sudo sed -i 's/^#\( *forward-socks5 *\/ *127.0.0.1:9050 \{1,\}\.\)/\1/' /etc/privoxy/config
	echo "Tor ON"
fi

exit 0
