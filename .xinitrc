#!/bin/sh
[ -z "$XDG_SESSION_OPT" ] && XDG_SESSION_OPT=$(cat /etc/hostname)

export XDG_CURRENT_DESKTOP=i3
export TERMINAL=alacritty
export EDITOR=nvim

if [ -f "$HOME/.config/$XDG_SESSION_OPT/.profile" ]; then
	# env variables ($PATH)
	. "$HOME/.config/$XDG_SESSION_OPT/.profile"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	# start some nice programs
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# strat window manager
[ -f "$HOME/.config/$XDG_SESSION_OPT/xinitrc" ] && \
	. "$HOME/.config/$XDG_SESSION_OPT/xinitrc"


# How to setup autologin in tty
# https://wiki.archlinux.org/title/getty
