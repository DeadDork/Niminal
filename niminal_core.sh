#!/bin/bash

# This script installs the core packages for the Lubuntu fork, Niminal. It assumes that the user is starting with a minimal Ubuntu install. It can also easily be amended to create an iso.

# Initial commands.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install just ackage and depends.
sudo apt-get --no-install-recommends -y install\
	lubuntu-core\
	acpi-support\
	avahi-daemon\
	bluez\
	bluez-alsa\
	bluez-cups\
	cups\
	cups-bsd\
	cups-client\
	kerneloops-daemon\
	laptop-detect\
	libnss-mdns\
	pcmciautils\
	policy-kit-desktop-privileges\
	desktop-file-utils\
	gvfs-backends\
	gvfs-fuse\
	xterm\
	pm-utils\
	update-notifier\
	wvdial\
	x11-utils\
	xdg-user-dirs\
	apport-gtk\
	blueman\
	gnome-keyring\
	gawk\
	linux-headers-generic\
	lxrandr\
	lxsession-edit\
	modemmanager\
	ntp\
	system-config-printer-gnome\
	usb-modeswitch\
	perl-doc\
	xfonts-terminus\
	encfs\
	samba\
	samba-common\
	wireless-tools\
	wpasupplicant\
	gdb\
	git\
	mercurial\
	cvs\
	openssh-server\
	pulseaudio\
	gstreamer0.10-pulseaudio\
	pulseaudio-module-x11\
	zip\
	unzip\
	xarchiver\
	xfe
