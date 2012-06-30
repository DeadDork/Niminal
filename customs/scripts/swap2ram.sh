#!/bin/bash

# This script manually moves swap memory back to RAM.

# My script borrows heavily from <https://help.ubuntu.com/community/SwapFaq/#Empty_Swap>. I changed it a bit to make it more verbose and easier to understand for a novice (like me).

# Sets 'mem' to the amount of RAM that is currently free.
mem=$(free | grep 'Mem:' | awk '{print $4}')
# Sets 'swap' to the amount of swap memory that is currently being used.
swap=$(free | grep 'Swap:' | awk '{print $3}')

if (( ${mem} < ${swap} )); then # Checks that 'mem' is not less than 'swap'.
	echo 'There is not enough RAM to write swap back, so nothing was done.'
	exit 1
else # If there is enough 'mem', then swap memory is moved into RAM and swap is reset.
	sudo swapoff -a
	sudo swapon -a
fi

exit 0
