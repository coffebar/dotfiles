if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	HYPR_BIN=/usr/bin/Hyprland
	if [ -f "$HYPR_BIN" ]; then
		echo 'Continue to Hyprland?'
		# you have 3 seconds to press any key except Return to load i3wm
		# otherwise Hyprland will be loaded
		read -t 3 -r -s -k 1 X
		if [ -z "$X" ]; then
			export XDG_SESSION_OPT="crab"
			export XDG_SESSION_TYPE="wayland"
			# Log WLR errors and logs to the hyprland log
			export HYPRLAND_LOG_WLR=1
			HYPR_CONF="$HOME/.config/$XDG_SESSION_OPT/hyprland.conf"
			PROFILE_SH="$HOME/.config/$XDG_SESSION_OPT/.profile"
			if [ -f "$PROFILE_SH" ]; then
					source "$PROFILE_SH"
			fi
			if [ -f "$HOME/dev/Hyprland/_build/src/Hyprland" ]; then
				HYPR_BIN="$HOME/dev/Hyprland/_build/src/Hyprland"
			fi
			exec $HYPR_BIN -c "$HYPR_CONF"
	  else
			exec startx > /dev/null
		fi
	else
		exec startx > /dev/null
	fi
fi
