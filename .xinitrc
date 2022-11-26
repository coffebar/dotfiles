#!/bin/sh

if lspci | grep 'UHD Graphics 620' ; then
	source $HOME/.config/kindle/.xinitrc
else
	source $HOME/.config/potato/.xinitrc
fi

