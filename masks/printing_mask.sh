#!/bin/sh

# This mask is intended to give niminal-core decent Linux ***printing*** capabilities.

# Prepare system to install packages.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install printing packages.
sudo apt-get --no-install-recommends -y install\
	cups\
	cups-bsd\
	cups-client\
	cups-driver-gutenprint\
	foomatic-db-compressed-ppds\
	foomatic-filters\
	hplip\
	libxp6\
	openprinting-ppds\
	printer-driver-c2esp\
	printer-driver-foo2zjs\
	printer-driver-min12xxw\
	printer-driver-pnm2ppa\
	printer-driver-ptouch\
	printer-driver-pxljr\
	printer-driver-sag-gdi\
	printer-driver-splix\
	simple-scan\
	system-config-printer-gnome
