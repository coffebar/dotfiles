if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	if [ -f /usr/bin/Hyprland ]; then
		echo 'Continue to Hyprland?'
		# you have 3 seconds to press any key except Return to load i3wm
		# otherwise Hyprland will be loaded
    read -t 3 -r -s -k 1 X
		if [ -z "$X" ]; then
			export XDG_SESSION_OPT="crab"
			export XDG_SESSION_TYPE="wayland"
			# Log WLR errors and logs to the hyprland log
			export HYPRLAND_LOG_WLR=1
			if [ -f "$HOME/.config/$XDG_SESSION_OPT/.profile" ]; then
					source "$HOME/.config/$XDG_SESSION_OPT/.profile"
			fi
			exec /usr/bin/Hyprland -c "$HOME/.config/$XDG_SESSION_OPT/hyprland.conf"
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
