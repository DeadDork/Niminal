#!/bin/bash

# Initial commands.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# While I get my act together with regards to niminal 0.2.0, niminal 0.1.0 will simply be a branch of lubuntu-core.
sudo apt-get install lubuntu-core --no-install-recommends -y

# However, it comes with some tweaks of my own!
sudo apt-get install\
	acpi-support\
	usb-modeswitch\
	pcmciautils\
	policykit-desktop-privileges\
	desktop-file-utils\
	gvfs-backends\
	gvfs-fuse\
	pm-utils\
	update-notifier\
	x11-utils\
	xdg-user-dirs\
	audacious\
	audacious-plugins\
	linux-headers-generic\
	ntp\
	scrot\
	xscreensaver\
	xfce4-power-manager\
	rxvt-unicode-256color\
	guake\
	xterm\
	elinks\
	rdesktop\
	zathura\
	xclip\
	cmus\
	feh\
	texlive-common\
	libreoffice-calc\
	gimp\
	seahorse\
	vlc\
	vlc-plugin-pulse\
	nmap\
	encfs\
	samba\
	samba-common\
	vim-gnome\
	vim-doc\
	unclutter\
	xfonts-terminus\
	scrot\
	network-manager-gnome\
	privoxy\
	squid3\
	git\
	mercurial\
	cvs\
	chromium-browser\
	r-base\
	ufw\
	openssh-server\
	openssh-client\
	imagemagick\
	pulseaudio\
	parcellite\
	trayer\
	libwebkitgtk-dev\
	libgtk2.0-dev\
	libsoup2.4-dev\
	mutt\
	libc6-dev\
	libao-dev\
	libgnutls-dev\
	libgcrypt11-dev\
	libjson0-dev\
	libfaad-dev\
	libmad0-dev\
	aptitude\
	vim-gtk

# Grab the dependencies for these projects as it is better to build them myself.
sudo apt-get build-dep\
	xxxterm\
	suckless-tools\
	scrotwm\
	freetds-common\
	sqsh

# Create directories.
if [ -d "${HOME}/programming_projects" ]; then
	:
else
	mkdir "${HOME}/programming_projects"
fi
if [ -d "${HOME}"/[Dd]ownloads ]; then
	:
else
	mkdir "${HOME}"/downloads
fi
if [ -d "${HOME}"/[Dd]ocuments ]; then
	:
else
	mkdir "${HOME}"/documents
fi
if [ -d "${HOME}"/programming_experiments ]; then
	:
else
	mkdir -p "${HOME}"/programming_experiments/{BASH,gawk,sed,SQL,hex,HTML,LaTeX,R,perl,python}
fi
if [ -d "${HOME}"/[Mm]anuals ]; then
	:
else
	mkdir "${HOME}"/manuals
fi

# Install various projects. These various projects need to be compiled and set by hand.
cd "${HOME}/programming_projects"
git clone git://opensource.conformal.com/xombrero.git
#cd xombrero
#make
#sudo make install
#cd ..
git clone git://opensource.conformal.com/spectrwm.git
#cd spectrwm
#make
#sudo make install
#cd ..
hg clone http://hg.suckless.org/st
#cd st
#make
#sudo make install
#cd ..
hg clone http://hg.suckless.org/dmenu
#cd dmenu
#make
#sudo make install
#cd ..
git clone git://github.com/PromyLOPh/pianobar.git
#cd pianobar
#make
#sudo make install
#cd ..
git clone git://git.code.sf.net/p/vimprobable/code
#cd vimprobable
#make
#sudo make install
#cd ..
cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login 
cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
#cd sqsh
#make
#sudo make install
#cd ..

# Need config files for:
#	* elinks
#	* vimprobable
#	* rxvt
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
