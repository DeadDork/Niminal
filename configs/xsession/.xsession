#!/usr/bin/env bash

# Load resources

#xrdb -merge .Xresources

# Set the background color

xsetroot -solid black

# Set up an icon tray

trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x000000 --height 12 &

# Fire up apps

#if [ -x /usr/bin/gnome-settings-daemon ]; then
#	gnome-settings-daemon &
#fi

if [ -x /usr/bin/xfce4-power-manager ]; then
	xfce4-power-manager &
fi

if [ -x /usr/bin/nm-applet ]; then
	nm-applet --sm-disable &
fi

if [ -x /usr/bin/parcellite ]; then
	parcellite &
fi

if [ -x /usr/bin/guake ]; then
	guake &
fi

#autocutsel &

xscreensaver -no-splash &

urxvtd -q -f -o

exec xmonad
