if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	export XDG_SESSION_OPT=$(cat /etc/hostname)
	export SESSION_CONF="$HOME/.config/$XDG_SESSION_OPT"

	HYPRLAND_BINARY=/usr/bin/Hyprland

	# if [[ "$XDG_SESSION_OPT" == "crab" ]] && [ -f "./dev/Hyprland/_build/src/Hyprland" ]; then
	# 	HYPRLAND_BINARY="./dev/Hyprland/_build/src/Hyprland"
	# fi
			
	if [ -f "$HYPRLAND_BINARY" ] && [ -f "$SESSION_CONF/hyprland.conf" ]; then
		echo 'Continue to Hyprland? Or press any key to load i3'
		read -t 2 -r -s -k 1 XKEY
		if [ -z "$XKEY" ]; then
			export XDG_SESSION_TYPE="wayland"
			# Log WLR errors and logs to the hyprland log
			export HYPRLAND_LOG_WLR=1

			if [ -f "$SESSION_CONF/.profile" ]; then
					source "$SESSION_CONF/.profile"
			fi
			exec $HYPRLAND_BINARY -c "$SESSION_CONF/hyprland.conf" 
		fi
	fi

	# fallback to xorg
	[[ "$XDG_SESSION_TYPE" == "tty" ]] && exec startx > /dev/null
fi
