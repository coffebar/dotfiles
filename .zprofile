# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
	PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ]; then
	PATH="$HOME/go/bin:$PATH"
fi

export PNPM_HOME="$HOME/.local/share/pnpm"
PATH="$PNPM_HOME:$HOME/.node_modules/bin:$PATH"

# remove absolute path leaks in release binary (rust)
export RUSTFLAGS="--remap-path-prefix $HOME=~"

export XDG_SESSION_OPT=$(cat /etc/hostname)
export SESSION_CONF="$HOME/.config/$XDG_SESSION_OPT"

if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CACHE_HOME=$HOME/.cache
	export XDG_CONFIG_HOME=$HOME/.config
	export XDG_DATA_HOME=$HOME/.local/share
	export XDG_STATE_HOME=$HOME/.local/state
fi

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
	# tty1, start GUI
	if [ "$XDG_VTNR" -eq 1 ]; then
		WM=/usr/bin/Hyprland
		if [ -f "$HOME/pets/Hyprland/build/src/Hyprland" ]; then
			WM=$HOME/pets/Hyprland/build/src/Hyprland
		fi

		USE_HYPRLAND=0
		if [ -f "$WM" ]; then
			if [ "$XDG_SESSION_OPT" = "potato" ]; then
				# check if nvidia is installed
				if ! [ -f "/usr/bin/nvidia-smi" ]; then
					USE_HYPRLAND=1
				fi
			else
				USE_HYPRLAND=1
			fi
		fi

		if [ "$USE_HYPRLAND" -eq 1 ]; then
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
		else
			# fallback to xorg
			exec startx > /dev/null
		fi
	fi
fi
