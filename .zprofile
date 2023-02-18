# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi
if [ -d "$HOME/.node_modules/bin" ] ; then
    PATH="$HOME/.node_modules/bin:$PATH"
fi

# remove absolute path leaks in release binary (rust)
export RUSTFLAGS="--remap-path-prefix $HOME=~"

export XDG_SESSION_OPT=$(cat /etc/hostname)
export SESSION_CONF="$HOME/.config/$XDG_SESSION_OPT"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
	# tty1, start GUI
	if [ "$XDG_VTNR" -eq 1 ]; then
		WM=/usr/bin/Hyprland
		if [ -f "$WM" ]; then
			if [[ "$XDG_SESSION_OPT" == "crab" ]]; then
				# autologin to Hyprland
				XKEY=''
			else
				# give 2 seconds to choose
				echo 'Continue to Hyprland? Or press any key to load i3'
				read -t 2 -r -s -k 1 XKEY
			fi
			if [ -z "$XKEY" ]; then
				HYPRLAND_CONFIG="$HOME/.config/hyprland/hyprland.conf"
				export XDG_SESSION_TYPE="wayland"
				# Log WLR errors and logs to the hyprland log
				export HYPRLAND_LOG_WLR=1
				# env variables for wayland
				export MOZ_ENABLE_WAYLAND=1
				export _JAVA_AWT_WM_NONREPARENTING=1
				export QT_QPA_PLATFORM=wayland-egl
				export GDK_BACKEND=wayland,x11
				export SDL_VIDEODRIVER=wayland
				export XKB_DEFAULT_OPTIONS=caps:backspace
				export GTK_THEME=Arc:dark
				# start wayland compositor
				exec $WM -c "$HYPRLAND_CONFIG" 
			fi
		fi

		# fallback to xorg
		[[ "$XDG_SESSION_TYPE" == "tty" ]] && exec startx > /dev/null

	fi
fi
