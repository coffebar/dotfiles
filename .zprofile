if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    pgrep Hyprland && read -r WAITING # pause when Hyprland is running
    exec startx > /dev/null
fi
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 2 ] && [ -f /usr/bin/Hyprland ]; then
		XDG_SESSION_TYPE="wayland"
		if [ -f $HOME/.config/crab/.profile ]; then
				source $HOME/.config/crab/.profile
		fi
    exec /usr/bin/Hyprland 
fi
# if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 3 ]; then
#     exec sway --unsupported-gpu
# fi
