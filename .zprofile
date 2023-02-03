if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	if [ -f /usr/bin/Hyprland ]; then
		echo 'Hyprland?'
    read -r X
		if [[ "$X" == 'y' ]]; then
			XDG_SESSION_TYPE="wayland"
			if [ -f $HOME/.config/crab/.profile ]; then
					source $HOME/.config/crab/.profile
			fi
			exec /usr/bin/Hyprland 
	  else
			exec startx > /dev/null
		fi
	else
		exec startx > /dev/null
	fi
fi

# if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 3 ]; then
#     exec sway --unsupported-gpu
# fi
