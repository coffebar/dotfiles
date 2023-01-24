#!/usr/bin/env bash
# start polybar for each monitor
# starting from the left

if [[ "$XDG_SESSION_OPT" == "kindle" ]]; then
	source $HOME/.config/kindle/polybar.sh
	exit
fi
if [[ "$XDG_SESSION_OPT" == "crab" ]]; then
	source $HOME/.config/kindle/polybar.sh
	exit
fi

source $HOME/.config/potato/polybar.sh

