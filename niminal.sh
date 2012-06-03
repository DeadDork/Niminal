#!/bin/bash

# Initial commands.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install aptitude

# I have decided to go hardcore, and NOT install lubuntu-core.

# Package and depends.
sudo apt-get --no-install-recommends -y install\
	anacron\
	bc\
	dbus-x11\
	ghostscript-x\
	inputattach\
	libpam-ck-connector\
	acpi-support\
	wireless-tools\
	wpasupplicant\
	usb-modeswitch\
	pcmciautils\
	desktop-file-utils\
	gvfs-fuse\
	pm-utils\
	update-notifier\
	apport-gtk\
	gdb\
	x11-utils\
	xdg-user-dirs\
	xfe\
	xarchiver\
	p7zip-full\
	cmus\
	linux-headers-generic\
	perl-doc\
	ntp\
	scrot\
	xscreensaver\
	xscreensaver-gl\
	xscreensaver-gl-extra\
	xfce4-power-manager\
	rxvt-unicode-256color\
	xfonts-terminus\
	rdesktop\
	zathura\
	xclip\
	feh\
	texlive-common\
	libreoffice-base\
	gimp\
	seahorse\
	mplayer2\
	nmap\
	encfs\
	samba\
	samba-common\
	vim-gnome\
	unclutter\
	network-manager-gnome\
	privoxy\
	squid3\
	git\
	mercurial\
	cvs\
	chromium-browser\
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
	foomatic-db-compressed-ppds\
	foomatic-filters\
	libsasl2-modules\
	libxp6\
	lightdm\
	lightdm-gtk-greeter\
	openprinting-ppds\
	printer-driver-pnm2ppa\
	rfkill\
	ubuntu-extras-keyring\
	xkb-data\
	xorg\
	avahi-daemon\
	cups\
	cups-bsd\
	cups-client\
	hplip\
	kerneloops-daemon\
	libnss-mdns\
	printer-driver-c2esp\
	printer-driver-foo2zjs\
	printer-driver-min12xxw\
	printer-driver-ptouch\
	printer-driver-pxljr\
	printer-driver-sag-gdi\
	printer-driver-splix\
	wvdial\
	libpulse-mainloop-glib0\
	blueman

# Package and depends and recommends.
sudo aptitude -r install\
	alsa-utils+\
	policykit-desktop-privileges+\
	gvfs-backends+\
	audacious-plugins+

# Package and depends, recommends and suggests.
sudo apt-get --install-suggests install\
	zip\
	elinks

# Only the depends.
sudo apt-get --no-install-recommends build-dep\
	xxxterm\
	suckless-tools\
	sqsh

# Create directories.
if [ ! -d "${HOME}"/Programming/programming_projects ]; then
	mkdir -p "${HOME}"/Programming/programming_projects
fi
if [ ! -d "${HOME}"/Programming/programming_experiments ]; then
	mkdir "${HOME}"/Programming/programming_experiments/{BASH,gawk,sed,SQL,hex,HTML,LaTeX,R,perl,python,sqsh}
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
