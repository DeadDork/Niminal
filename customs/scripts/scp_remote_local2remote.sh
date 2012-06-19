#!/bin/sh

# This is a useful script for scp-ing stuff via a reverse-ssh tunnel. It assumes the user has already used something like ssh2remote.sh to connect to the remote computer.

# This particular script will scp from the physical computer to the remote computer the user has ssh'ed to.

read -p "Remote host port number: " remote_port
read -p "Local host name: " local_host
read -p "Enter the file name (with its full file path) that you want to scp: " source
read -p "Enter the destination directory (with its full file path): " destination

scp -r -P "${remote_port}" "${local_host}"@localhost:"${source}" "${destination}"
