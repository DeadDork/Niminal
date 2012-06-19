#!/bin/bash

# This script assumes that you are beginning with a minimal ubuntu install.

# Directory location of customizing files. This assumes that you are running this install script from the git's ./ directory (i.e. the one niminal.sh is in).
custom_figs="$(pwd)/customs"

# Create general home directories.
mkdir -p "${HOME}"/Programming/{programming_projects,programming_experiments/{BASH,awk,sed,SQL,haskell,hex,HTML,LaTeX,R,perl,python,sqsh}}

mkdir -p "${HOME}"/Downloads/{chromium,elinks,open_source,xombrero,vimprobable}

mkdir -p "${HOME}"/Pictures/screenshots

mkdir -p "${HOME}"/Documents/manuals

# Prepare to install packages.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install just packages and their depends.

# Libraries, tools and other non-interactables.
sudo apt-get --no-install-recommends -y install\
	acpi-support\
	alsa-base\
	alsa-utils\
	apparmor-profiles\
	apparmor-utils\
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
	dzen2\
	elinks-doc\
	encfs\
	foomatic-db-compressed-ppds\
	foomatic-filters\
	gawk\
	gawk-doc\
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
	hplip\
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
	nmap\
	notify-osd\
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
	python-software-properties\
	readline-common\
	rfkill\
	samba\
	samba-common\
	squid3\
	texlive-latex-recommended\
	texlive-latex-recommended-doc\
	trayer\
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
	alsamixergui\
	apport-gtk\
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
	update-notifier\
	vim\
	vim-latexsuite\
	vim-gtk\
	vlc\
	vlc-plugin-pulse\
	volumeicon-alsa\
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
sudo apt-get --no-install-recommends -y build-dep\
	freetds-common\
	libghc-xmonad-dev\
	libghc-xmonad-contrib-dev\
	sqsh\
	suckless-tools\
	xmonad\
	xxxterm

if [ ! $? = 0 ]; then
	echo "Depends install fail." >> ~/install.errors
fi

# Installs various open-source projects from source. Many of these use a niminal patch, which could break future releases. If that happens, the broken source will not compile, and an error will be redirected into ~/install.errors.
# If any of the patches fail, do alert me of this, so that I can fix them
# N.B. As all of the following software is installed from source, there is no Debian or Ubuntu maintainer keeping an eye on safety, etc. Accordingly, all of these projects are installed in HOME/local, where root access isn't necessary for their installation.

# First, though, to enter user info in .hgrc & .gitrc

# Mercurial
read -p "Mercurial user name (e.g. 'Nimrod Omer, aka DeadDork <nimrodomer@gmail.com>')? " hgun
echo -e "[ui]\nusername = ${hgun}" >> "${HOME}"/.hgrc

echo 

# Git
read -p "Git user name (e.g. 'DeadDork')? " gituser
git config --global user.name "${gituser}"
read -p "Git user email (e.g. 'nimrodomer@gmail.com')? " gitemail
git config --global user.email "${gitemail}"
read -p "Git user favored text editor (e.g. 'vim')? " giteditor
git config --global core.editor "${giteditor}"
read -p "Git user favored diff tool (e.g. 'vimdiff')? " gitdiff
git config --global merge.tool "${gitdiff}"

# On to the source.
cd "${HOME}"/Downloads/open_source

# dmenu -- simple dynamic menu.
hg clone http://hg.suckless.org/dmenu/
cd dmenu
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
mkdir freetds
cd freetds
wget ftp://ftp.ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-stable.tgz # The CVS tip didn't have 'configure'...
tar -xvf freetds*
cd freetds*
./configure --prefix="${HOME}"/local
make clean
make install
if [ ! $? = 0 ]; then
	echo "freetds install fail." >> ~/install.errors
fi
cd ../..

# pianobar -- command-line Pandora player.
git clone git://github.com/PromyLOPh/pianobar.git
cd pianobar
git apply --check "${custom_figs}"/pianobar/0001-Added-USER_PATH-to-make-patching-pianobar-easy.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/pianobar/0001-Added-USER_PATH-to-make-patching-pianobar-easy.patch
	make clean
	make install
	git commit -a -m "MakeFile patch applied."
else
	echo "Pianobar install fail." >> ~/install.errors
fi
cd ..

# SQSH -- powerful replacement for isql.
echo -e "-=-=-=-=NOTE=-=-=-=-\nJust hit ENTER at the password prompt below.\n-=-=-=-=END NOTE=-=-=-=-"
cvs -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh login
cvs -z3 -d:pserver:anonymous@sqsh.cvs.sourceforge.net:/cvsroot/sqsh co -P sqsh
cd sqsh
SYBASE="${HOME}/local"
export SYBASE
./configure --with-readline --prefix="${HOME}"/local --mandir='${prefix}/local/share/man'
make clean
make install install.man
if [ ! $? = 0 ]; then
	echo "SQSH install fail." >> ~/install.errors
fi
cd ..

# st -- simple terminal emulator.
hg clone http://hg.suckless.org/st/
cd st
patch --dry-run -f -p1 <"${custom_figs}"/st/niminalization.patch
if [ $? = 0 ]; then
	hg import "${custom_figs}"/st/niminalization.patch
	make clean
	make install
else
	echo "st install fail." >> ~/install.errors
fi
cd ..

# Vimprobable -- ultra-light web browser.
git clone git://git.code.sf.net/p/vimprobable/code
mv code vimprobable
git apply --check "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configs.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/vimprobable/0001-Niminal-Vimprobable-configs.patch
	make clean
	make install
	cp -r "${custom_figs}"/vimprobable/vimprobable "${HOME}"/.config/
	git commit -a -m "Niminal configs & MakeFile patch applied."
else
	"Vimprobable install fail." >> ~/install.errors
fi
cd ..

# xmonad -- ultra-lightweight window manager.
darcs get http://code.haskell.org/xmonad
cd xmonad
runhaskell Setup.lhs configure --user --prefix="${HOME}"/local
runhaskell Setup.lhs build
runhaskell Setup.lhs install --user
if [ $? = 0 ]; then
	cd man
	pandoc -s -w man xmonad.1.* -o "${HOME}"/local/share/man/man1/xmonad.1 # This seems like a totally stupid way to do this. However, I don't understand how Setup.lhs works, so it's this way for now.
	cd ..
	cabal update
	#cabal install cabal-install # This command SHOULD work, but it's been giving me some problems. I'll address this in a later version.
	cabal install xmonad-contrib
	cp -r "${custom_figs}"/xmonad/xmonad "${HOME}"/.xmonad/
	sed -i 's|USER_PATH|'"${HOME}"'|g' "${HOME}"/.xmonad/xmonad.hs
	sed -i 's|USER_PATH|'"${HOME}"'|g' "${HOME}"/.xmonad/.conky_dzen

	# N.B. the .xsession & xmonad.desktop assume that xmonad was installed correctly. If it wasn't, oi...
	cp "${custom_figs}"/xsession/xsession "${HOME}"/.xsession
	link "${HOME}"/.xsession "${HOME}"/.xinitrc
	if [ ! -d /usr/share/xsessions ]; then
		sudo mkdir /usr/share/xsessions
	fi
	sudo cp "${custom_flags}"/xmonad/xmonad.png /usr/share/icons/
	sudo cp "${custom_figs}"/xsession/xmonad.desktop /usr/share/xsessions/
	if [ ! $? = 0 ]; then
		echo "Couldn't set up xmonad.desktop." >> install.errors
	fi
else
	echo "xmonad install fail." >> ~/install.errors
fi

# Xombrero -- lightweight secure tabbing browser.
git clone git://opensource.conformal.com/xombrero
cd xombrero/linux
git apply --check "${custom_figs}"/xombrero/0001-Makefile-changed-to-install-xombrero-in-HOME-local.patch
if [ $? = 0 ]; then
	git apply "${custom_figs}"/xombrero/0001-Makefile-changed-to-install-xombrero-in-HOME-local.patch
	make clean
	make install
	git commit -a -m "MakeFile patch applied."
	cp "${custom_figs}"/xombrero/xombrero.conf "${HOME}"/.xombrero.conf
else
	echo "Xombrero install fail." >> ~/install.errors
fi
cd ../..

# Samba
mkdir -p "${HOME}"/samba/share
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.master
sudo cp "${custom_figs}"/samba/smb.conf.niminal /etc/samba/
sudo sed -i 's|PATH_TO_HOME|'"${HOME}"'|' /etc/samba/smb.conf.niminal
sudo testparm -s /etc/samba/smb.conf.niminal /etc/samba/smb.conf
if [ ! $? = 0 ]; then
	echo "Couldn't generate good smb.conf." >> install.errors
fi

# Proxies
if [ -e /etc/apt/sources.list ]; then 
	sudo echo -e "\n# Tor & privoxy as offered by the Tor Project folks.\ndeb     http://deb.torproject.org/torproject.org $(lsb_release -c | awk '{print $2}') main" >> /etc/apt/sources.list
	gpg --keyserver keys.gnupg.net --recv 886DDD89
	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
	sudo apt-get update
else
	echo "Failed to add Tor Project deb." >> ~/install.errors
fi
sudo apt-get install tor privoxy
patch --dry-run -f -p1 /etc/squid3/squid.conf "${custom_figs}"/proxies/squid.patch
if [ $? = 0 ]; then
	sudo patch -f -p1 /etc/squid3/squid.conf "${custom_figs}"/proxies/squid.patch
	sudo echo 'http_proxy="http://127.0.0.1:3128"' >> /etc/environment
else
	echo "Failed to patch squid3." >> install.errors
fi

# Set firewall.
# This only lets in ssh & samba, and then only on a local network. Admittedly, this is very aggressive, but I don't have a need not to be.
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/16 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/16 to any port 135,139,145
sudo ufw allow proto udp from 192.168.0.0/16 to any port 137,138

# Scripts
cp -r "${custom_figs}"/scripts "${HOME}"/Programming/programming_projects/
cp "${HOME}"/Programming/programming_projects/scripts/* "${HOME}"/local/bin/

# Simple config's
cp -r "${custom_figs}"/elinks/elinks "${HOME}"/.elinks

cp -r "${custom_figs}"/parcellite/parcellite "${HOME}"/.config

cp "${custom_figs}"/profile/profile "${HOME}"/.profile

cp "${custom_figs}"/urxvt/Xdefaults "${HOME}"/.Xdefaults

cp "${custom_figs}"/vim/vimrc "${HOME}"/.vimrc
cp -r "${custom_figs}"/vim/vim "${HOME}"/.vim

cp -r "${custom_figs}"/xfe "${HOME}"/.config

cp -r "${custom_figs}"/xfce4/xfce4 "${HOME}"/.config

cp -r "${custom_figs}"/xfe/xfe "${HOME}"/.config

cp "${custom_figs}"/xscreensaver/xscreensaver "${HOME}"/.xscreensaver

exit 0
