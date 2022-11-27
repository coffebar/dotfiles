#!/usr/bin/env bash
# start polybar for each monitor
# starting from the left

if [[ "$XDG_SESSION_OPT" == "kindle" ]]; then
	source $HOME/.config/kindle/polybar.sh
	exit
else
	source $HOME/.config/potato/polybar.sh
fi

