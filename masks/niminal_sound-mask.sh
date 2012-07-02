#!/bin/sh

# This mask is intended to give niminal ***sound*** management similar to Ubuntu-Desktop.

# Prepare system to install packages.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Printing packages.
sudo apt-get --no-install-recommends -y install\
