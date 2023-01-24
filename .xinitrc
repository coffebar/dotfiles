#!/bin/sh

LSPCI_OUT=$(lspci)
if echo $LSPCI_OUT | grep 'UHD Graphics 620' ; then
	source $HOME/.config/kindle/xinitrc
else
	if echo $LSPCI_OUT | grep 'Iris Xe Graphics' ; then
		source $HOME/.config/crab/xinitrc
	else
		source $HOME/.config/potato/xinitrc
	fi
fi

