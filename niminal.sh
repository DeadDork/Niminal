#!/bin/bash

# Run this instead of installing from the .iso. Doesn't necessarily need a minimal Ubuntu base install, but it's recommended.
# For a minimal Ubuntu install, follow the directions from psychocats til just the point after your first login to the barebones install, but before you install the packages. Directions here: <http://www.psychocats.net/ubuntu/minimal>.

# Directory location of custom configs files. This assumes that you are running this install script from it's . directory.
custom_figs="$(pwd)/configs"

# Create main home directories.
if [ ! -d "${HOME}"/Programming/{programming_projects,programming_experiments} ]; then
	mkdir -p "${HOME}"/Programming/{programming_projects,programming_experiments/{BASH,awk,sed,SQL,hex,HTML,LaTeX,R,perl,python,sqsh}}
fi
if [ ! -d "${HOME}"/[Dd]ownloads ]; then
	mkdir -p "${HOME}"/Downloads/{open_source,chromium,xombrero,elinks,vimprobable}
fi
if [ ! -d "${HOME}"/[Dd]ocuments ]; then
	mkdir "${HOME}"/Documents/manuals
fi

# Initial commands.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install just packages and their depends.

# Libraries, tools and other non-interactables.
sudo apt-get --no-install-recommends -y install\
	acpi-support\
	alsa-base\
	alsa-utils\
	aspell\
	aspell-de\
	aspell-en\
	aspell-es\
	aspell-fr\
	aspell-he\
	anacron\
	avahi-daemon\
	bluez\
	bluez-alsa\
	bluez-cups\
	bluez-utils\
	ca-certificates\
	cabal-install\
	conky\
	cups\
	cups-bsd\
	cups-client\
	cvs\
	dbus-x11\
	elinks-doc\
	encfs\
	foomatic-db-compressed-ppds\
	foomatic-filters\
	freetds-common\
	gawk\
	gdb\
	genisoimage\
	ghc\
	git\
	gnash\
	gnome-keyring\
	gnupg2\
	gnupg-doc\
	gstreamer0.10-pulseaudio\
	gvfs-backends\
	gvfs-fuse\
	inputattach\
	kerneloops-daemon\
	laptop-detect\
	libao-dev\
	libc6-dev\
	libfaad-dev\
	libgcrypt11-dev\
	libgnutls-dev\
	libgtk2.0-dev\
	libjson0-dev\
	libmad0-dev\
	libnss-mdns\
	libpam-ck-connector\
	libsasl2-modules\
	libsoup2.4-dev\
	libwebkitgtk-dev\
	libxp6\
	lightdm\
	lightdm-gtk-greeter\
	linux-headers-generic\
	lubuntu-restricted-extras\
	mercurial\
	mixmaster\
	mpd\
	ntp\
	nvidia-common\
	openprinting-ppds\
	pcmciautils\
	perl-doc\
	pm-utils\
	policy-kit-desktop-privileges\
	privoxy\
	pulseaudio\
	pulseaudio-module-x11\
	readline-common\
	rfkill\
	samba\
	samba-common\
	squid3\
	ubuntu-extras-keyring\
	unzip\
	url-view\
	usb-modeswitch\
	wireless-tools\
	wpasupplicant\
	wvdial\
	x11-utils\
	xclip\
	xfonts-terminus\
	xkb-data\
	xorg\
	zip

# Shells, GUI's and other interactables.
sudo apt-get --no-install-recommends -y install\
	apport-gtk\
	bc\
	cmus\
	elinks\
	feh\
	gmrun\
	guake\
	ghostscript-x\
	keynav\
	mpc\
	mplayer\
	mutt\
	network-manager-gnome\
	openssh-server\
	parcellite\
	radare2\
	rdesktop\
	rxvt-unicode-256color\
	r-recommended\
	scrot\
	system-config-printer-gnome\
	xfce4-power-manager\
	xscreensaver\
	xscreensaver-gl\
	xscreensaver-gl-extra\
	unclutter\
	vim-latexsuite\
	vim-gtk\
	xarchiver\
	xfe\
	xli\
	zathura

# Extra programs that are not minimal, but that I regularly use.
sudo apt-get --no-install-recommends -y install\
	abiword\
	chromium-browser\
	gnumeric\
	gimp\
	libreoffice-calc\
	libreoffice-writer

# Only install the depends (for installing from sources further down).
sudo apt-get --no-install-recommends build-dep\
	dzen2\
	sqsh\
	suckless-tools\
	xmonad\
	libghc-xmonad-contrib-dev\
	libghc-xmonad-dev\
	xxxterm

# Installs various open-source projects. Many of these use a niminal patch, which could break future releases. If that happens, the broken source will revert to the master branch--i.e. away from the niminal branch--and recompile the vanilla.
# If any of the patches fail, do alert me of this, so that I can fix it.

cd "${HOME}"/Downloads/open_source

# dmenu
if [ ! -d dmenu ]; then
	hg clone http://hg.suckless.org/dmenu/
else
	cd dmenu
	hg pull
	cd ..
fi
cd dmenu
if [[ -e /usr/local/bin/dmenu  || -e /usr/bin/dmenu ]]; then # In case it is already installed. Reinstalling doubles the man files, etc. Big PITA. Easier to uninstall, then reinstall.
	sudo make uninstall
fi
make clean
sudo make install
cd ..

# pianobar
if [ ! -d pianobar ]; then
	git clone git://github.com/PromyLOPh/pianobar.git
else
	cd pianobar
	git pull
	cd ..
fi
cd pianobar
if [[ -e /usr/local/bin/pianobar  || -e /usr/bin/pianobar ]]; then # In case it is already installed. Reinstalling doubles the man files, etc. Big PITA. Easier to uninstall, then reinstall.
	sudo make uninstall
fi
make clean
sudo make install
cd ..

# SQSH
if [ ! -d sqsh ]; then
	echo -e "-=-=-=-=NOTE=-=-=-=-\nJust hit ENTER at the password prompt here.\n-=-=-=-=END NOTE=-=-=-=-"
	cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login
	cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
else
	cd sqsh
	cvs update
	cd ..
fi
cd sqsh
if [[ -e /usr/local/bin/sqsh  || -e /usr/bin/sqsh ]]; then # In case it is already installed. Reinstalling doubles the man files, etc. Big PITA. Easier to uninstall, then reinstall.
	sudo make uninstall
fi
SYBASE="/user/local"
export SYBASE
./configure --with-readline --with-x
make clean
sudo make install
cd ..

# st -- simple terminal.
if [ ! -d st ]; then
	hg clone http://hg.suckless.org/st/
else
	cd st
	hg pull
	cd ..
fi
cd st
if [[ -e /usr/local/bin/st  || -e /usr/bin/st ]]; then # In case it is already installed. Reinstalling doubles the man files, etc. Big PITA. Easier to uninstall, then reinstall.
	sudo make uninstall
fi
make clean
sudo make install
cd ..

# Vimprobable
if [ ! -d vimprobable ]; then
	git clone git://git.code.sf.net/p/vimprobable/code
	mv code vimprobable
else
	cd vimprobable
	git pull
	cd ..
fi
cd vimproable
if [[ -e /usr/local/bin/vimprobable  || -e /usr/bin/vimprobable ]]; then # In case it is already installed. Reinstalling doubles the man files, etc. Big PITA. Easier to uninstall, then reinstall.
	sudo make uninstall
fi
git apply --check "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configuration.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configuration.patch
fi
make clean
sudo make install
cd ..

# Xmonad
# Xombrero


# Xombrero -- light-weight browser.
if [ ! -d xombrero ]; then
	git clone git://opensource.conformal.com/xombrero
else
	cd xombrero
	git pull origin
	cd ..
fi
cd xombrero/linux
make clean
sudo make install
cd ../..

# Set firewall. Admittedly, this is very aggressive, but I haven't had any needs to not be.
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/16 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/16 to any port 135,139,145
sudo ufw allow proto udp from 192.168.0.0/16 to any port 137,138

# Need config files for:
#	* elinks
#	* vimprobable
#	* vim (gvim + vim + vim-tiny)
#	* samba
#	* .xsession/.xinitrc
#	* privoxy + squid3 + tor
#	* freetds (AMEND FOR GITHUB!!!)
#	* zathura
#	* mutt
#	* xmonad
#	* dzen2
#	* conky
#	* dcp-linux
#	* transmission

# Miscelani:
#	* ssh scripts
#	* 2xclip
#	* sqsh scripts
#	* rdesktop scripts (AMEND FOR GITHUB!!!)
#	* manuals (e.g. if-then, bash, etc.)
#	* MIT License
#	* PATCHING
