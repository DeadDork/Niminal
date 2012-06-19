#!/bin/sh

# This simple--but surprisingly useful--script allows the user to create an ssh tunnel with a remote host.

read -p 'Remote host? ' remote_host
read -p 'Remote port? ' remote_port
read -p 'Remote IP? ' remote_ip

ssh -R "${remote_port}":localhost:22 "${remote_host}"@"${remote_ip}"
