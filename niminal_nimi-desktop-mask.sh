#!/bin/bash

# The directory of the source.
niminal_installer_dir=$(pwd)

# This script installs and sets up a more full-featured desktop environment on top of a niminal-core install.

# Initial commands.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install just ackage and depends.
sudo apt-get --no-install-recommends -y install\
	aptitude\
	lubuntu-software-center\
	vim-gtk\
	vim-latexsuite\
	rxvt-unicode-lite\
	audacious\
	audacious-plugins\
	chromium-browser\
	gnome-mplayer\
	libreoffice-calc\
	libreoffice-writer\
	gpicview\
	gucharmap\
	guvcview\
	network-manager-gnome\
	scrot\
	transmission\
	xfce4-power-manager\
	xscreensaver\
	xscreensaver-gl\
	xscreensaver-gl-extra\
	rdesktop\
	zathura\
	xclip\
	texlive-common\
	gimp\
	seahorse\
	unclutter\
	privoxy\
	squid3\
	r-recommended\
	parcellite\
	libwebkitgtk-dev\
	libgtk2.0-dev\
	libsoup2.4-dev\
	libc6-dev\
	libao-dev\
	libgnutls-dev\
	libgcrypt11-dev\
	libjson0-dev\
	libfaad-dev\
	libmad0-dev\
	mutt\
	freetds-common\
	awesome\
	awesome-extra\
	elinks\
	elinks-doc\
	gnash\
	lubuntu-restricted-extras\
	xli\
	conky\

# Only install the depends.
sudo apt-get --no-install-recommends build-dep\
	xxxterm\
	suckless-tools\
	sqsh

# Create directories.
if [ ! -d "${HOME}"/Programming/programming_projects ]; then
	mkdir -p "${HOME}"/Programming/programming_projects
fi
if [ ! -d "${HOME}"/Programming/programming_experiments ]; then
	mkdir "${HOME}"/Programming/programming_experiments/{BASH,awk,sed,SQL,hex,HTML,LaTeX,R,perl,python,sqsh}
fi
if [ ! -d "${HOME}"/[Dd]ownloads ]; then
	mkdir "${HOME}"/Downloads
fi
if [ ! -d "${HOME}"/[Dd]ocuments ]; then
	mkdir "${HOME}"/Documents
fi
if [ ! -d "${HOME}"/Documents/[Mm]anuals ]; then
	mkdir "${HOME}"/Documents/manuals
fi

# Install various neat source projects.

# The Xombrero browser.
cd "${HOME}"/Programming/programming_projects
if [ ! -d xombrero ]; then
	cp -r "${niminal_installer_dir}"/source/xombrero .
fi
cd xombrero
git checkout master
git pull origin
git checkout nimis_config
cd linux
make clean
sudo make install
cd ../..

# SimpleTerm.
if [ ! -d stterm ]; then
	cp -r "${niminal_installer_dir}"/source/stterm .
fi
cd stterm

if [ ! -d dmenu ]; then
	hg clone http://hg.suckless.org/dmenu
	cd dmenu
	make clean
	sudo make install
	cd ..
fi
if [ ! -d pianobar ]; then
	git clone git://github.com/PromyLOPh/pianobar.git
	cd pianobar
	make clean
	sudo make install
	cd ..
else
	cd pianobar
	status=$(git pull origin | awk '/Already up-to-date/')
	if [[ "${status}" =~ 'Already up-to-date' ]]; then
		:
	else
		make clean
		sudo make install
	fi
	cd ..
fi
if [ ! -d vimprobable ]; then
	git clone git://git.code.sf.net/p/vimprobable/code
	mv code vimprobable2
fi
if [ ! -d sqsh ]; then
	cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login 
	cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
fi

# Set firewall.
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/16 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/16 to any port 135,139,145
sudo ufw allow proto udp from 192.168.0.0/16 to any port 137,138

# Need config files for:
#	* elinks
#	* vimprobable
#	* vim
#	* samba
#	* .xsession/.xinitrc
#	* privoxy + squid3
#	* freetds
#	* zathura
#	* mutt

# Need to setup:
#	* chromium-browser

# Miscelani:
#	* ssh scripts
#	* 2xclip
#	* sqsh scripts
#	* rdesktop scripts
#	* manuals (e.g. if-then bash manual)
#	* MIT License
#	* transfer over to new computer all important files from old computer (e.g. TrueNorthDecrypt)
