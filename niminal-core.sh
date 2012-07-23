#!/bin/bash

# This install script assumes that you are beginning with a minimal ubuntu install.

# Directory location of customizing files. This assumes that you are running this install script from the niminal-core's git home directory (i.e. the directory niminal-core.sh is in).
custom_figs="$(pwd)/customs"

# Create home subdirectories.
mkdir -p "${HOME}"/Programming/{programming_projects,programming_experiments/{BASH,awk,sed,SQL,haskell,hex,HTML,LaTeX,R,perl,python,sqsh}}

mkdir -p "${HOME}"/Downloads/{chromium,elinks,open_source,xombrero,vimprobable}

mkdir -p "${HOME}"/Pictures/screenshots

mkdir -p "${HOME}"/Documents/manuals

# Prepare system to install packages.
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# Install just packages and their depends.

# From the Lubuntu Desktop environment minimal installation meta-package <http://packages.ubuntu.com/precise/lubuntu-core>.

# Depends.
sudo apt-get --no-install-recommends -y install\
	alsa-base\
	alsa-utils\
	anacron\
	bc\
	ca-certificates\
	dbus-x11\
	ghostscript-x\
	inputattach\
	libpam-ck-connector\
	libsasl2-modules\
	lightdm\
	lightdm-gtk-greeter\
	nvidia-common\
	rfkill\
	ttf-dejavu-core\
	ttf-freefont\
	ubuntu-extras-keyring\
	unzip\
	wireless-tools\
	wpasupplicant\
	xkb-data\
	xorg\
	zip

test ! $? -eq 0 && echo 'Lubuntu-core depends install fail.' >> "${HOME}"/install.errors

# Recommends.
sudo apt-get --no-install-recommends -y install\
	gucharmap\
	kerneloops-daemon\
	pcmciautils

test ! $? -eq 0 && echo 'Lubuntu-core recommends install fail.' >> "${HOME}"/install.errors

# My own set of packages.

# Non-interactables.
sudo apt-get --no-install-recommends -y install\
	apparmor-profiles\
	apparmor-utils\
	cabal-install\
	conky\
	cvs\
	darcs\
	dzen2\
	ghc\
	git\
	mercurial\
	pandoc\
	patch\
	xfonts-terminus

test ! $? -eq 0 && echo "Non-interactables install fail." >> "${HOME}"/install.errors

# Shells, GUI's and other interactables.
sudo apt-get --no-install-recommends -y install\
	rxvt-unicode-256color

test ! $? -eq 0 && echo "Interactables install fail." >> "${HOME}"/install.errors

# Only install the depends of the following (for installing programs from source further down).
sudo apt-get --no-install-recommends -y build-dep\
	libghc-xmonad-dev\
	libghc-xmonad-contrib-dev\
	suckless-tools\
	xmonad

test ! $? -eq 0 && echo "Depends install fail." >> "${HOME}"/install.errors

# Installs various open-source projects from source. Many of these use a niminal patch, which could break future releases. If that happens, the broken source will not compile, and an error will be redirected into "${HOME}"/install.errors.
# If any of the patches fail, do alert me of this, so that I can fix them
# N.B. As all of the following software is installed from source, there is no Debian or Ubuntu maintainer keeping an eye on safety, etc. Neither am I sure that these are digitally signed and checked when cloned (or otherwise). Accordingly, all of these projects are installed in HOME/local, where root access isn't necessary for their installation.

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

# To the source!
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
	echo "dmenu install fail." >> "${HOME}"/install.errors
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
	echo "st install fail." >> "${HOME}"/install.errors
fi
cd ..

# xmonad -- ultra-lightweight window manager.
darcs get http://code.haskell.org/xmonad
cd xmonad
runhaskell Setup.lhs configure --user --prefix="${HOME}"/.local
runhaskell Setup.lhs build
runhaskell Setup.lhs install --user
if [ $? = 0 ]; then
	cd man
	pandoc -s -w man xmonad.1.* -o "${HOME}"/.local/share/man/man1/xmonad.1 # This seems like a totally stupid way to do this. However, I don't understand how Setup.lhs works, so it's this way for now.
	cd ..
	cabal update
	#cabal install cabal-install # This command SHOULD work, but it's been giving me some problems. I'll address this in a later version.
	cabal install xmonad-contrib
	cp -r "${custom_figs}"/xmonad/xmonad "${HOME}"/.xmonad/
	sed -i -e 's|USER_PATH|'"${HOME}"'|g' -e 's|CMUS_VERSION|'"$(cmus --version | sed -n '1 p')"'|' "${HOME}"/.xmonad/xmonad.hs
	sed -i 's|USER_PATH|'"${HOME}"'|g' "${HOME}"/.xmonad/.conky_dzen

	# N.B. the .xsession & xmonad.desktop assume that xmonad was installed correctly. If it wasn't, oi...
	sed 's|USER_PATH|'"${HOME}"'|g' <"${custom_figs}"/xsession/xsession >"${HOME}"/.xsession
	link "${HOME}"/.xsession "${HOME}"/.xinitrc
	if [ ! -d /usr/share/xsessions ]; then
		sudo mkdir /usr/share/xsessions
	fi
	sudo cp "${custom_figs}"/xmonad/xmonad.png /usr/share/icons/ # Is this sudo a security hole? Is it possible to stick trojans in png's? I can imagine that it is. If so, I might was to do away with this.
	sudo cp "${custom_figs}"/xsession/xmonad.desktop /usr/share/xsessions/xmonad.desktop
	sudo sed -i 's|USER_PATH|'"${HOME}"'|g' /usr/share/xsessions/xmonad.desktop
	if [ ! $? = 0 ]; then
		echo "Couldn't set up xmonad.desktop." >> install.errors
	fi
else
	echo "xmonad install fail." >> "${HOME}"/install.errors
fi

# Settings configuration.

# Proxies
sudo bash -c "echo -e \"\n# Tor & privoxy as offered by the Tor Project folks.\ndeb     http://deb.torproject.org/torproject.org $(lsb_release -c | awk '{print $2}') main\" >>/etc/apt/sources.list"
if [ ! $? = 0 ]; then
	echo "Failed to add Tor Project deb." >> "${HOME}"/install.errors
fi
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
sudo apt-get update
sudo apt-get install tor privoxy
patch --dry-run -f -p1 /etc/squid3/squid.conf "${custom_figs}"/proxies/squid.patch
if [ $? = 0 ]; then
	sudo bash -c "patch -f -p1 /etc/squid3/squid.conf ${custom_figs}/proxies/squid.patch"
	sudo bash -c "echo 'http_proxy=\"http://127.0.0.1:3128\"' >> /etc/environment"
else
	echo "Failed to patch squid3." >> install.errors
fi

# Set firewall.
# This only lets in ssh & samba, and then only on a local network. Admittedly, this is very aggressive, but I don't have a need not to be.
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/16 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/16 to any port 135,139,445
sudo ufw allow proto udp from 192.168.0.0/16 to any port 137,138

# Swap configuration.
grep -q -i 'vm\.swappiness *= *[0-9]' /etc/sysctl.conf
if [ $? -eq 0 ]; then
	sudo cp /etc/sysctl.conf /etc/sysctl.conf.original
	sudo bash -c "sed -i 's/\(vm\.swappiness *= *\)[0-9]*/\110/' /etc/sysctl.conf"
else
	sudo bash -c "echo -e '\n# Default swappiness = 60. As this is a desktop machine, I'm changing this to 10.\nvm.swappiness=10' >> /etc/sysctl.conf"
fi

# Simple config's.
cp "${custom_figs}"/urxvt/Xdefaults "${HOME}"/.Xdefaults

exit 0
