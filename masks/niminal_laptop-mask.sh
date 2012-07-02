#!/bin/sh

# This mask is intended to make niminal more usable on ***laptops***.

# Prepare system to install packages.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install laptop packages.
sudo apt-get --no-install-recommends -y install\
	acpi-support\
	blueman\
	bluez\
	bluez-alsa\
	bluez-utils\
	laptop-detect\
	lxrandr\

test "$(aptitude search '^cups$' | egrep '[[:space:]]+cups[[:space:]]+' | awk '{print $1}')" != 'i' && sudo apt-get --no-install-recommends -y install bluez-cups # There's probably a better way to test whether the cups package is installed.

# As soon as I resolve the network-manager applet bug, I want to add to the package install list:
#	mobile-broadband-provider-info
#	modemmanager
#	network-manager-gnome
#	gnome-keyring