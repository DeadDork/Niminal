#!/bin/bash

# This script assumes you already have some *buntu distro installed (or optionally Debian).

# Directory location of custom configs files. This assumes that you are running this install script from it's . directory.
custom_figs="$(pwd)/customs"

# Create main home directories.
if [ ! -d "${HOME}"/bin ]; then
	mkdir "${HOME}"/bin
fi

if [ ! -d /usr/local/man/man1 ]; then
	sudo mkdir -p /usr/local/man/man1
fi

if [ ! -d "${HOME}"/Programming/programming_projects ]; then
	mkdir -p "${HOME}"/Programming/programming_projects/scripts
fi
if [ ! -d "${HOME}"/Programming/programming_experiments ]; then
	mkdir -p "${HOME}"/Programming/programming_experiments/{BASH,awk,sed,SQL,haskell,hex,HTML,LaTeX,R,perl,python,sqsh}
fi

if [ ! -d "${HOME}"/Downloads/chromium ]; then
	mkdir -p "${HOME}"/Downloads/chromium
fi
if [ ! -d "${HOME}"/Downloads/elinks ]; then
	mkdir "${HOME}"/Downloads/elinks
fi
if [ ! -d "${HOME}"/Downloads/open_source ]; then
	mkdir "${HOME}"/Downloads/open_source
fi
if [ ! -d "${HOME}"/Downloads/xombrero ]; then
	mkdir "${HOME}"/Downloads/xombrero
fi
if [ ! -d "${HOME}"/Downloads/vimprobable ]; then
	mkdir "${HOME}"/Downloads/vimprobable
fi

if [ ! -d "${HOME}"/.config/vimprobable ]; then
	mkdir -p "{HOME}"/.config/vimprobable
fi

if [ ! -d "${HOME}"/Pictures/screenshots ]; then
	mkdir -p "${HOME}"/Pictures/screenshots
fi

if [ ! -d "${HOME}"/Documents/manuals ]; then
	mkdir -p "${HOME}"/Documents/manuals
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
	darcs\
	dbus-x11\
	elinks-doc\
	encfs\
	foomatic-db-compressed-ppds\
	foomatic-filters\
	freetds-common\
	gawk\
	gdb\
	gdebi-core\
	genisoimage\
	ghc6\
	git\
	gnash\
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
	pandoc\
	pcmciautils\
	perl-doc\
	pm-utils\
	policy-kit-desktop-privileges\
	pulseaudio\
	pulseaudio-module-x11\
	readline-common\
	rfkill\
	samba\
	samba-common\
	squid3\
	ubuntu-extras-keyring\
	unzip\
	unclutter\
	usb-modeswitch\
	videolan-doc\
	wireless-tools\
	wpasupplicant\
	wvdial\
	x11-utils\
	xclip\
	xfonts-terminus\
	xkb-data\
	xorg\
	xscreensaver-gl\
	xscreensaver-gl-extra\
	zip

# Shells, GUI's and other interactables.
sudo apt-get --no-install-recommends -y install\
	bc\
	cmus\
	elinks\
	feh\
	gmrun\
	ghostscript-x\
	gv\
	irssi\
	irssi-scripts\
	mpc\
	mplayer\
	mutt\
	openssh-server\
	parcellite\
	radare2\
	rdesktop\
	rxvt-unicode-256color\
	r-recommended\
	screen\
	scrot\
	system-config-printer-gnome\
	vim\
	vim-latexsuite\
	vim-gtk\
	vlc\
	vlc-plugin-pulse\
	wicd-gtk\
	wicd-cli\
	xarchiver\
	xfe\
	xfce4-power-manager\
	xli\
	xscreensaver\
	zathura

# Extra programs that are not minimal, but that I regularly use.
sudo apt-get --no-install-recommends -y install\
	abiword\
	chromium-browser\
	galculator\
	gnumeric\
	gimp\
	libreoffice-calc\
	libreoffice-writer

# Only install the depends (for installing from sources further down).
sudo apt-get build-dep\
	sqsh\
	suckless-tools\
	xxxterm

# Installs various open-source projects. Many of these use a niminal patch, which could break future releases. If that happens, the broken source will revert to the master branch--i.e. away from the niminal branch--and recompile the vanilla.
# If any of the patches fail, do alert me of this, so that I can fix it.

cd "${HOME}"/Downloads/open_source

# dmenu -- simple dynamic menu.
if [ ! -d dmenu ]; then
	hg clone http://hg.suckless.org/dmenu/
	cd dmenu
else
	cd dmenu
	hg pull
	make clean
fi
make
cp dmenu dmenu_run "${HOME}"/bin
sudo cp dmenu.1 /usr/local/man/man1/
cd ..

# pianobar -- command-line Pandora player.
if [ ! -d pianobar ]; then
	git clone git://github.com/PromyLOPh/pianobar.git
	cd pianobar
else
	cd pianobar
	git pull
	make clean
fi
make
cp pianobar "${HOME}"/bin
sudo cp "${custom_figs}"/pianobar/pianobar.sh /usr/local/bin/pianobar
cd ..

# SQSH -- powerful replacement for isql.
if [ ! -d sqsh ]; then
	echo -e "-=-=-=-=NOTE=-=-=-=-\nJust hit ENTER at the password prompt below.\n-=-=-=-=END NOTE=-=-=-=-"
	cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login
	cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
	cd sqsh
else
	cd sqsh
	cvs update
	make clean
fi
SYBASE="/user/local"
export SYBASE
./configure --with-readline --with-x
make
cp sqsh "${HOME}"/bin
sudo cp "${custom_figs}"/sqsh/sqsh.sh /usr/local/bin/sqsh
sudo cp doc/sqsh.1 /usr/local/man/man1/
cd ..

# st -- simple terminal emulator.
if [ ! -d st ]; then
	hg clone http://hg.suckless.org/st/
cd st
else
	cd st
	hg pull
	make clean
fi
patch --dry-run -f -p1 < "${custom_figs}"/st/st_niminal.patch
if [ $? = 0 ]; then
	hg import "${custom_figs}"/st/st_niminal.patch
fi
make
cp st "${HOME}"/bin
sudo cp st.1 /usr/local/man/man1/
cd ..

# Vimprobable -- ultra-light web browser.
if [ ! -d vimprobable ]; then
	git clone git://git.code.sf.net/p/vimprobable/code
	mv code vimprobable
	cd vimproable
else
	cd vimprobable
	git pull
	make clean
fi
git apply --check "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configuration.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configuration.patch
fi
make
cp vimprobable "${HOME}"/bin
if [ ! -d "${HOME}"/.config/vimprobable ]; then
	mkdir -p "${HOME}"/.config/vimprobable
fi
cp -r "${custom_figs}"/vimprobable/vimprobable "${HOME}"/.config/
sudo cp vimprobable2.1 /usr/local/share/man/man1/
sudo cp vimprobablerc.5 /usr/local/share/man/man5/
cd ..

# xmonad -- ultra-lightweight window manager.
if [ ! -d xmonad ]; then
	darcs get http://code.haskell.org/xmonad
	cd xmonad
else
	cd xmonad
	darcs pull
fi
runhaskell Setup.lhs configure --user --prefix="${HOME}"
runhaskell Setup.lhs build
runhaskell Setup.lhs install --user
cd man
sudo pandoc -s -w man xmonad.1.* -o /usr/local/share/man/man1/xmonad.1
cabal update
cabal install cabal-install
"${HOME}"/.cabal/bin/cabal install xmonad-contrib
if [ ! -d "${HOME}"/.xmonad ]; then
	cp -r "${custom_figs}"/xmonad/xmonad "${HOME}"/.xmonad/
fi

# Xombrero -- light-weight browser.
if [ ! -d xombrero ]; then
	git clone git://opensource.conformal.com/xombrero
cd xombrero/linux
else
	cd xombrero
	git pull origin
	make clean
fi
make
cp xmobrero "${HOME}"/bin/
if [ ! -d "${HOME}"/share/xombrero ]; then
	mkdir "${HOME}"/share/xombrero
fi
cp *.[Pp][Nn][Gg] tld-rules style.css "${HOME}"/share/xombrero
cp "${custom_figs}"/xombrero/playflash.sh "${HOME}"/share/xombrero
cp "${custom_figs}"/xombrero/xombrero.conf "${HOME}"/.xombrero.conf
cd ../..

# Proxies
sudo apt-add-repository ppa:ubun-tor/ppa
sudo apt-get update
sudo apt-get install tor privoxy
patch --dry-run -f -p1 < "${custom_figs}"/proxies/squid.patch
if [ $? = 0 ]; then
	sudo patch -f -p1 < "${custom_figs}"/proxies/squid.patch
fi
cp "${custom_figs}"/proxies/ToggleTor.sh "${HOME}"/Programming/programming_projects/scripts/
cp "${custom_figs}"/proxies/ToggleTor.sh "${HOME}"/bin/

# Set firewall. Admittedly, this is very aggressive, but I haven't had any need to not be.
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/16 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/16 to any port 135,139,145
sudo ufw allow proto udp from 192.168.0.0/16 to any port 137,138

# Simple config's
cp -r "${custom_figs}"/elinks/elinks "${HOME}"/.elinks

cp -r "${custom_figs}"/parcellite/parcellite "${HOME}"/.config

patch --dry-run -f -p1 /etc/samba/smb.conf < "${custom_figs}"/samba/smb.patch
if [ $? = 0 ]; then
	sudo patch -f -p1 /etc/samba/smb.conf < "${custom_figs}"/samba/smb.patch
fi

sudo cp "${custom_figs}"/pianobar/pianobar.sh /usr/local/bin/pianobar

cp -r "${custom_figs}"/scripts "${HOME}"/Programmings/programming_projects/
sudo cp "${custom_figs}"/scripts/ToggleTor/ToggleTor.sh /usr/local/bin/ToggleTor

cp "${custom_figs}"/urxvt/Xdefaults "${HOME}"/.Xdefaults

cp "${custom_figs}"/vimrc "${HOME}"/.vimrc
cp -r "${custom_figs}"/vim "${HOME}"/.vim

cp -r "${custom_figs}"/xfe "${HOME}"/.config

cp -r "${custom_figs}"/xfce4/xfce4 "${HOME}"/.config

cp -r "${custom_figs}"/xfe/xfe "${HOME}"/.config

cp "${custom_figs}"/xscreensaver/xscreensaver "${HOME}"/.xscreensaver

cp "${custom_figs}"/xsession/xsession "${HOME}"/.xsession
link "${HOME}"/.xsession "${HOME}"/.xinitrc

exit 0
