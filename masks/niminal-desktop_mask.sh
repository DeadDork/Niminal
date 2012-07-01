#!/bin/bash

# This mask is intended to give niminal-core normal ***desktop*** functionality, such as a file system manager, gui text editor, etc.

##########################################################################################

# Prepatory stuff.

# Directory location of customizing files. This assumes that you are running this install script from the niminal-core's git home directory (i.e. the directory niminal-core.sh is in)--*NOT* the scrip the mask is in (yeah, yeah).
custom_figs="$(pwd)/customs"

# Readies system to install packages.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

##########################################################################################

# Installs packages from apt repositories.

# From Lubuntu-Desktop <http://packages.ubuntu.com/precise/lubuntu-desktop>

# Depends.
sudo apt-get --no-install-recommends -y install\
	gvfs-backends\
	gvfs-fuse\
	pm-utils\
	wvdial\
	x11-utils

test ! $? -eq 0 && echo 'Niminal desktop mask: Lubuntu-Desktop depends install fail.' >> "${HOME}"/install.errors

# Recommends.
sudo apt-get --no-install-recommends -y install\
	abiword\
	apport-gtk\
	audacious\
	audacious-plugins\
	chromium-browser\
	fonts-liberation\
	gnumeric\
	linux-headers-generic\
	lubuntu-restricted-extras\
	mtpaint\
	ntp\
	scrot\
	software-properties-gtk\
	usb-modeswitch\
	xfce4-power-manager\
	xscreensaver

test ! $? -eq 0 && echo 'Niminal desktop mask: Lubuntu-Desktop recommends install fail.' >> "${HOME}"/install.errors

#############################################

# My own package preferences.

# Non-interactables.
sudo apt-get --no-install-recommends -y install\
	apparmor-notify\
	elinks-doc\
	aspell\
	aspell-de\
	aspell-en\
	aspell-es\
	aspell-fr\
	aspell-he\
	encfs\
	gawk\
	gawk-doc\
	gdb\
	gdebi-core\
	gnupg2\
	gnupg-doc\
	libao-dev\
	libc6-dev\
	libfaad-dev\
	libgcrypt11-dev\
	libgnutls-dev\
	libgtk2.0-dev\
	libjson0-dev\
	libmad0-dev\
	libsoup2.4-dev\
	libwebkitgtk-dev\
	lubuntu-restricted-extras\
	macchanger\
	mplayer-doc\
	nmap\
	notify-osd\
	perl-doc\
	samba\
	samba-common\
	texlive-latex-recommended\
	texlive-latex-recommended-doc\
	xclip\
	xscreensaver-gl\
	xscreensaver-gl-extra

test ! $? -eq 0 && echo 'Niminal desktop mask: non-interactables install fail.' >> "${HOME}"/install.errors

# Shells, GUI's and other interactables.
sudo apt-get --no-install-recommends -y install\
	alsamixergui\
	cmus\
	elinks\
	feh\
	galculator\
	gimp\
	gmrun\
	gv\
	htop\
	irssi\
	irssi-scripts\
	mplayer-gui\
	openssh-server\
	parcellite\
	radare2\
	rdesktop\
	r-recommended\
	screen\
	scrot\
	trayer\
	vim\
	vim-latexsuite\
	vim-gtk\
	volumeicon-alsa\
	wicd-gtk\
	wicd-cli\
	xarchiver\
	xfe\
	xfce4-power-manager\
	xli\
	zathura

test ! $? -eq 0 && echo 'Niminal desktop mask: interactables install fail.' >> "${HOME}"/install.errors

#############################################

# Only installs the depends of the following packages (for installing programs from source further down).
sudo apt-get --no-install-recommends -y build-dep\
	freetds-common\
	sqsh\
	xxxterm

test ! $? -eq 0 && echo 'Niminal desktop mask: source dependencies install fail.' >> "${HOME}"/install.errors

##########################################################################################

# Installs various open-source projects from source.

# Many of these use a niminal patch, which could break future releases. If that happens, the broken source will not compile, and an error will be redirected into ~/install.errors.

# If any of the patches fail, do alert me to this, so that I can fix them.

# N.B. As all of the following software is installed from source, there is no Debian or Ubuntu maintainer keeping an eye on safety, etc. Neither am I sure that these are digitally signed and checked when cloned (or otherwise). Accordingly, all of these projects are installed in HOME/local, where root access isn't necessary for their installation, which will hopefully keep any mischief to a minimum.

# To the source!
cd "${HOME}"/Downloads/open_source

#############################################

# freetds -- free, reverse-engineered version of Microsoft's TDS.
mkdir freetds
cd freetds
wget ftp://ftp.ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-stable.tgz # The CVS tip didn't have 'configure' last I checked.
tar -xvf freetds*
cd freetds*
./configure --prefix="${HOME}"/.local
make clean
make install
test ! $? -eq 0 && echo 'Niminal desktop mask: freetds install fail.' >> "${HOME}"/install.errors
cd ../..

#############################################

# pianobar -- command-line Pandora player.
git clone git://github.com/PromyLOPh/pianobar.git
cd pianobar
git apply --check "${custom_figs}"/pianobar/0001-Added-USER_PATH-to-make-patching-pianobar-easy.patch
if [ $? -eq 0 ]; then
	git apply "${custom_figs}"/pianobar/0001-Added-USER_PATH-to-make-patching-pianobar-easy.patch
	make clean
	make install
	git commit -a -m "MakeFile patch applied."
else
	echo 'Niminal desktop mask: pianobar install fail.' >> "${HOME}"/install.errors
fi
cd ..

#############################################

# SQSH -- a powerful replacement for isql.
echo -e "\n-=-=-=-=NOTE=-=-=-=-\nJust hit ENTER at the password prompt below.\n-=-=-=-=END NOTE=-=-=-=-\n"
cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login
cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
cd sqsh
SYBASE="${HOME}/.local"
export SYBASE
./configure --with-readline --prefix="${HOME}"/.local --mandir='${prefix}/local/share/man'
make clean
make install install.man
test ! $? -eq 0 && echo "Niminal desktop mask: sqsh install fail." >> "${HOME}"/install.errors
cd ..

#############################################

# Vimprobable -- ultra-lightweight web browser.
git clone git://git.code.sf.net/p/vimprobable/code
mv code vimprobable
cd vimprobable
git apply --check "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configs.patch
if [ $? -eq 0 ]; then
	git apply "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configs.patch
	make clean
	make install
	cp -r "${custom_figs}"/vimprobable/vimprobable "${HOME}"/.config/
	git commit -a -m "Niminal configs & MakeFile patch applied."
else
	'Niminal desktop mask: vimprobable install fail.' >> "${HOME}"/install.errors
fi
cd ..

#############################################

# Xombrero -- lightweight secure tabbing browser.
git clone git://opensource.conformal.com/xombrero
cd xombrero/linux
git apply --check "${custom_figs}"/xombrero/0001-Makefile-changed-to-install-xombrero-in-HOME-local.patch
if [ $? -eq 0 ]; then
	git apply "${custom_figs}"/xombrero/0001-Makefile-changed-to-install-xombrero-in-HOME-local.patch
	make clean
	make install
	git commit -a -m "MakeFile patch applied."
	cp "${custom_figs}"/xombrero/xombrero.conf "${HOME}"/.xombrero.conf
else
	echo 'Niminal desktop mask: xombrero install fail.' >> "${HOME}"/install.errors
fi
cd ../..

#############################################

# Homebrew scripts.
cp "${custom_figs}"/scripts/* "${HOME}"/.local/bin/

##########################################################################################

# Settings configuration.

# Samba
mkdir -p "${HOME}"/samba/share
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.master
sudo bash -c "sed 's|PATH_TO_HOME|${HOME}|g' < ${custom_figs}/samba/smb.conf.niminalized > /etc/samba/smb.conf.niminalized"
sudo bash -c "testparm -s /etc/samba/smb.conf.niminalized > /etc/samba/smb.conf"
test ! $? -eq 0 && echo "Couldn't generate good smb.conf." >> install.errors

#############################################

# Simple config's.
cp -r "${custom_figs}"/elinks/elinks "${HOME}"/.elinks

cp -r "${custom_figs}"/parcellite/parcellite "${HOME}"/.config

cp "${custom_figs}"/profile/profile "${HOME}"/.profile

cp "${custom_figs}"/vim/vimrc "${HOME}"/.vimrc

cp -r "${custom_figs}"/vim/vim "${HOME}"/.vim

cp -r "${custom_figs}"/xfce4/xfce4 "${HOME}"/.config

cp -r "${custom_figs}"/xfe/xfe "${HOME}"/.config

cp "${custom_figs}"/xscreensaver/xscreensaver "${HOME}"/.xscreensaver

##########################################################################################

exit 0
