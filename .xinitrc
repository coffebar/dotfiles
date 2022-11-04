#!/bin/sh

/usr/bin/autorandr -c

export TERMINAL=alacritty
export EDITOR=nvim

if xrandr --listmonitors | grep ' 2560' ; then
	export GDK_SCALE=""
	export QT_SCREEN_SCALE_FACTORS=""
	export QT_FONT_DPI=""
else
	export GDK_SCALE=2
	export QT_AUTO_SCREEN_SCALE_FACTOR=1
	export QT_SCREEN_SCALE_FACTORS="2"
	export QT_FONT_DPI=200
fi

if [ -f $HOME/.profile ]; then
	# env variables
    source $HOME/.profile
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec i3




# Note
# to setup autologin look at this manual
# https://wiki.archlinux.org/title/getty
