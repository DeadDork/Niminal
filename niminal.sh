#!/bin/bash

# 0.1.x notes:
# The 0.1.x version series took a minimal ubuntu install, and added to it preferred packages. This seems like a good idea for a minimal Linux distro based on Ubuntu, at least in theory, but in practice the final product was quite shoddy. For one, I was never confident that it was secure and stable. Second, it was quite ugly. Third, the UI left a lot to be desired.

# 0.2.x notes:
# In the 0.2.x version series, I cherry-picked Lubuntu packages to create a base install I could have some confidence in, then added to it a few choice packages. This series was plagued by problems, too: 1) Spectrwm proved to be a flop 2) while I had high confidence when using Lubuntu, when I logged in to Spectrwm I was never quite as sanguine.

# 0.3.x notes:
# I had hoped to fork the 0.3.x series, such that my custom base Lubuntu install would be configured to have the best of Awesome & Lubuntu. However, this turned out to entail a huge undertaking, so I'm going to leave that to the 0.4.x series (which I'll work on in conjunction with Cnaan over the next couple of months). Instead, the 0.3.x series will take my custom Lubuntu install, and I'll simply mod from within Lubuntu (e.g. changing to the Awesome WM from OpenBox via LXSession). I expect to use this series for the next 2 - 3 months.

# Initial commands.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install aptitude

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
	vim-gtk\
	vim-latexsuite\
	rxvt-unicode-lite\
	pm-utils\
	update-notifier\
	wvdial\
	x11-utils\
	xdg-user-dirs\
	audacious\
	audacious-plugins\
	apport-gtk\
	blueman\
	chromium-browser\
	gnome-keyring\
	gnome-mplayer\
	gawk\
	libreoffice-calc\
	libreoffice-writer\
	gpicview\
	gucharmap\
	guvcview\
	ibus\
	linux-headers-generic\
	lxrandr\
	lxsession-edit\
	modemmanager\
	network-manager-gnome\
	ntp\
	scrot\
	system-config-printer-gnome\
	transmission\
	usb-modeswitch\
	xfce4-power-manager\
	cmus\
	perl-doc\
	xscreensaver-gl\
	xscreensaver-gl-extra\
	xfonts-terminus\
	rdesktop\
	zathura\
	xclip\
	feh\
	texlive-common\
	gimp\
	seahorse\
	encfs\
	samba\
	samba-common\
	xscreensaver\
	wireless-tools\
	wpasupplicant\
	gdb\
	unclutter\
	privoxy\
	squid3\
	git\
	mercurial\
	cvs\
	r-recommended\
	molly-guard\
	openssh-server\
	pulseaudio\
	gstreamer0.10-pulseaudio\
	pulseaudio-module-x11\
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
	rlwrap\
	awesome\
	awesome-extra\
	zip\
	unzip\
	elinks\
	elinks-doc\
	xarchiver\
	gnash\
	xli\
	conky\
	xfe

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

# Install various projects. These various projects need to be compiled and set by hand.
cd "${HOME}"/Programming/programming_projects
if [ ! -d xombrero ]; then
	git clone git://opensource.conformal.com/xombrero.git
fi
if [ ! -d spectrwm ]; then
	git clone git://opensource.conformal.com/spectrwm.git
fi
if [ ! -d stterm ]; then
	hg clone http://hg.suckless.org/st
fi
if [ ! -d dmenu ]; then
	hg clone http://hg.suckless.org/dmenu
fi
if [ ! -d pianobar ]; then
	git clone git://github.com/PromyLOPh/pianobar.git
fi
if [ ! -d vimprobable ]; then
	git clone git://git.code.sf.net/p/vimprobable/code
	mv code vimprobable
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
