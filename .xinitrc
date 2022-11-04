#!/bin/sh

if [ -f $HOME/hdpi_setup.sh ]; then
    /usr/bin/sudo /bin/bash $HOME/hdpi_setup.sh
	# Important!
	# sudo will ask for a password and you will not see the prompt
	# You need to create a file:
	# /etc/sudoers.d/hdpi
	#
	# <user> ALL=(root) NOPASSWD:/bin/bash /home/<user>/hdpi_setup.sh
	#
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

/usr/bin/autorandr -c

exec i3

## ------ NOTE ------ ##
# autologin setup with getty (default service)
# @link https://wiki.archlinux.org/title/getty
