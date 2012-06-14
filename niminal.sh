#!/bin/bash

# This script assumes you already have some *buntu distro installed (or optionally Debian).

# Directory location of custom config files. This assumes that you are running this install script from the git's  . directory (i.e. the one niminal.sh is in).
custom_figs="$(pwd)/customs"

# Create directories.
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
	gawk\
	gdb\
	gdebi-core\
	genisoimage\
	ghc\
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
	patch\
	pcmciautils\
	perl-doc\
	pm-utils\
	policykit-desktop-privileges\
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

if [ ! $? = 0 ]; then
	echo "Non-interactables install fail." >> ~/install.errors
fi


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

if [ ! $? = 0 ]; then
	echo "Interactables install fail." >> ~/install.errors
fi

# Extra programs that are not minimal, but that I regularly use.
sudo apt-get --no-install-recommends -y install\
	abiword\
	chromium-browser\
	galculator\
	gnumeric\
	gimp\
	libreoffice-calc\
	libreoffice-writer

if [ ! $? = 0 ]; then
	echo "Bloaties install fail." >> ~/install.errors
fi

# Only install the depends (for installing from sources further down).
sudo apt-get build-dep  -y --no-install-recommends\
	freetds-common\
	libghc-xmonad-dev\
	libghc-xmonad-contrib-dev\
	sqsh\
	suckless-tools\
	xmonad\
	xxxterm

if [ ! $? = 0 ]; then
	"Depends install fail." >> ~/install.errors

# Installs various open-source projects. Many of these use a niminal patch, which could break future releases. If that happens, the broken source will revert to the master branch--i.e. away from the niminal branch--and recompile the vanilla.
# If any of the patches fail, do alert me of this, so that I can fix it.
# N.B. As this is open source software, there is no guarantee of safety, etc. Accordingly, everything that follows is installed in HOME/local, where root access isn't necessary for their installation (and also any possible malice/whatnot).

cd "${HOME}"/Downloads/open_source

# dmenu -- simple dynamic menu.
if [ ! -d dmenu ]; then
	hg clone http://hg.suckless.org/dmenu/
else
	cd dmenu
	make uninstall
	cd ..
fi
cd dmenu
hg pull
patch --dry-run -p1 -f config.mk "${custom_figs}"/dmenu/make_file.patch
if [ $? = 0 ]; then
	hg import "${custom_figs}"/dmenu/make_file.patch
	make clean
	make install
else
	echo "dmenu install fail." >> ~/install.errors
fi
cd ..

# freetds -- free, reverse-engineered version of Microsoft's TDS.
if [ ! -d freetds ]; then
	mkdir freetds
	cd freetds
	wget ftp://ftp.ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-stable.tgz # The CVS tip didn't have 'configure'...
	tar xvf freetds*
else
	cd freetds/freetds*
	make uninstall
	cd ..
fi
cd freetds*
./configure --prefix="${HOME}"/local
make clean
make install
if [ ! $? = 0 ]; then
	echo "freetds install fail." >> ~/install.errors
fi
cd ../..

# pianobar -- command-line Pandora player.
if [ ! -d pianobar ]; then
	git clone git://github.com/PromyLOPh/pianobar.git
else
	cd pianobar
	make uninstall
	cd ..
fi
cd pianobar
git pull
git apply --check "${custom_figs}"/pianobar/0001-Added-USER_PATH-to-make-patching-pianobar-easy.patch
if [ $? = 0 ]; then
	git apply 0001-Added-USER_PATH-to-make-patching-pianobar-easy.patch
	make clean
	make install
	git commit -a -m "MakeFile patch applied."
else
	echo "Pianobar install fail." >> ~/install.errors
fi
cd ..

# SQSH -- powerful replacement for isql.
if [ ! -d sqsh ]; then
	echo -e "-=-=-=-=NOTE=-=-=-=-\nJust hit ENTER at the password prompt below.\n-=-=-=-=END NOTE=-=-=-=-"
	cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login
	cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
else
	cd sqsh
	make uninstall
	cd ..
fi
cd sqsh
cvs update
SYBASE="${HOME}/local"
export SYBASE
./configure --with-readline --prefix="${HOME}"/local
make clean
make install
if [ ! $? = 0 ]; then
	echo "SQSH install fail." >> ~/install.errors
cd ..

# st -- simple terminal emulator.
if [ ! -d st ]; then
	hg clone http://hg.suckless.org/st/
else
	cd st
	make uninstall
	cd ..
fi
cd st
hg pull
patch --dry-run -f -p1 <"${custom_figs}"/st/make-file_and_word-jumping-functionality_and_fonts.patch 
if [ $? = 0 ]; then
	hg import "${custom_figs}"/st/st_niminal.patch
	make clean
	make install
else
	echo "st install fail." >> ~/install.errors
fi
cd ..

# Vimprobable -- ultra-light web browser.
if [ ! -d vimprobable ]; then
	git clone git://git.code.sf.net/p/vimprobable/code
	mv code vimprobable
else
	cd vimprobable
	make uninstall
	cd ..
fi
cd vimprobable
git pull
git apply --check "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configs.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configs.patch
	make clean
	make install
	git commit -a -m "Niminal configs & MakeFile patch applied."
else
	"Vimprobable install fail." >> ~/install.errors
fi
if [ ! -d "${HOME}"/.config/vimprobable ]; then
	mkdir -p "${HOME}"/.config/vimprobable
fi
cp -r "${custom_figs}"/vimprobable/vimprobable "${HOME}"/.config/
cd ..

# xmonad -- ultra-lightweight window manager.
# As darcs & cabal don't have much in the way of uninstallation, I am simply going to let previous installed files get overwritten. Hopefully that won't lead to any problems down the road. The alternative is a pain in the butt find command.
if [ ! -d xmonad ]; then
	darcs get http://code.haskell.org/xmonad
fi
cd xmonad
darcs pull
runhaskell Setup.lhs configure --user --prefix="${HOME}"/local 
runhaskell Setup.lhs build
runhaskell Setup.lhs install --user
if [ ! -d "${HOME}"/.xmonad ]; then
	cp -r "${custom_figs}"/xmonad/xmonad "${HOME}"/.xmonad/
	sed -i 's|USER_PATH|'"${HOME}"'|g' "${HOME}"/.xmonad/xmonad.hs
fi
cd man
sudo pandoc -s -w man xmonad.1.* -o "${HOME}"/local/share/man/man1/xmonad.1
cabal update
#cabal install cabal-install # This command SHOULD work, but it's been giving me some problems. I'll address this in a later version.
cabal install xmonad-contrib

# Xombrero -- lightweight secure tabbing browser.
if [ ! -d xombrero ]; then
	git clone git://opensource.conformal.com/xombrero
else
	cd xombrero/linux
	make uninstall
	cd ../..
fi
cd xombrero
git pull
cd linux
git apply --check "${custom_figs}"/xombrero/0001-Makefile-changed-to-install-xombrero-in-HOME-local.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/xombrero/0001-Makefile-changed-to-install-xombrero-in-HOME-local.patch
	make clean
	make install
	git commit -a -m "MakeFile patch applied."
else
	echo "Xombrero install fail." >> ~/install.errors
fi
cp "${custom_figs}"/xombrero/xombrero.conf "${HOME}"/.xombrero.conf
cd ../..

# Proxies
sudo apt-add-repository ppa:ubun-tor/ppa
sudo apt-get update
sudo apt-get install tor privoxy
patch --dry-run -f -p1 /etc/squid3/squid.conf "${custom_figs}"/proxies/squid.patch
if [ $? = 0 ]; then
	patch -f -p1 /etc/squid3/squid.conf "${custom_figs}"/proxies/squid.patch
else
	echo "Failed to patch squid3." >> install.errors
fi

# Set firewall. It only lets in ssh & samba, and then only on a local network. Admittedly, this is very aggressive, but I don't have a need not to be.
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/16 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/16 to any port 135,139,145
sudo ufw allow proto udp from 192.168.0.0/16 to any port 137,138

# LightDM
if [ ! -d /usr/share/xsessions ]; then
	sudo mkdir /usr/share/xsessions
fi
sudo cp "${custom_figs}"/xsession/xmonad.desktop /usr/share/xsessions/
if [ ! $? = 0 ]; then
	echo "Couldn't set-up xmonad.desktop." >> install.errors
fi
cp "${custom_figs}"/xsession/xsession "${HOME}"/.xsession
link "${HOME}"/.xsession "${HOME}"/.xinitrc

# Scripts
cp -r "${custom_figs}"/scripts "${HOME}"/Programming/programming_projects/
cp "${HOME}"/Programming/programming_projects/scripts/ToggleTor/ToggleTor.sh "${HOME}"/local/bin/ToggleTor

# Simple config's
cp -r "${custom_figs}"/elinks/elinks "${HOME}"/.elinks

cp -r "${custom_figs}"/parcellite/parcellite "${HOME}"/.config

patch --dry-run -f -p1 /etc/samba/smb.conf < "${custom_figs}"/samba/smb.patch
if [ $? = 0 ]; then
	sudo patch -f -p1 /etc/samba/smb.conf < "${custom_figs}"/samba/smb.patch
else
	echo "Couldn't patch smb.conf." >> install.errors
fi

cp "${custom_figs}"/urxvt/Xdefaults "${HOME}"/.Xdefaults

cp "${custom_figs}"/vimrc "${HOME}"/.vimrc
cp -r "${custom_figs}"/vim "${HOME}"/.vim

cp -r "${custom_figs}"/xfe "${HOME}"/.config

cp -r "${custom_figs}"/xfce4/xfce4 "${HOME}"/.config

cp -r "${custom_figs}"/xfe/xfe "${HOME}"/.config

cp "${custom_figs}"/xscreensaver/xscreensaver "${HOME}"/.xscreensaver

exit 0
