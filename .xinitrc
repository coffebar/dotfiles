#!/bin/sh
[ -z "$XDG_SESSION_OPT" ] && export XDG_SESSION_OPT="$(cat /etc/hostname)"

export SESSION_CONF="$HOME/.config/$XDG_SESSION_OPT"
export XDG_CURRENT_DESKTOP=i3
export TERMINAL=alacritty
export EDITOR=nvim


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	# start some nice programs
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# strat window manager
if [ -f "$SESSION_CONF/xinitrc" ]; then
	. "$SESSION_CONF/xinitrc"
else
	i3
fi


# How to setup autologin in tty
# https://wiki.archlinux.org/title/getty
