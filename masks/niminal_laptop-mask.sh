#!/bin/bash

# This mask is intended to make niminal more usable on ***laptops***.

# Directory location of customizing files.
# This assumes that this mask is installed using the mask installer in the top Niminal git directory. 
custom_figs="$(pwd)/customs"

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
	lxrandr

# Installs bluez-cups if cups is installed.
# (There's probably a better way to test whether the cups package is installed...)
test "$(aptitude search '^cups$' | egrep '[[:space:]]+cups[[:space:]]+' | awk '{print $1}')" != 'i' && sudo apt-get --no-install-recommends -y install bluez-cups

# Configures xfce4 power manager for better laptop battery life.
cp -r "${custom_figs}"/xfce4/xfce4 "${HOME}"/.config

# As soon as I resolve the network-manager applet bug, I want to add to the package install list:
#	mobile-broadband-provider-info
#	modemmanager
#	network-manager-gnome
#	gnome-keyring

# Of course, eventually I also want to manage my networking from scripts and the cli, so it's a race!
