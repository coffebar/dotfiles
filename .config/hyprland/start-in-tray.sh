#!/bin/bash
# start waybar and programs with tray icons after pause

waybar_loop() {
	# restart waybar on crash (after suspend mode)
	WAYBAR_RESTARTS=0
	while [ $WAYBAR_RESTARTS != 6 ]; do # limited to 5 restars
		waybar
		((WAYBAR_RESTARTS++))
		notify-send -a "start-in-tray.sh" "Waybar crashed!"
		sleep 1
	done
}

# wait for xdg-desktop-portal-hyprland to start
until pgrep -f 'xdg-desktop-portal-hyprland'; do sleep 2; done

# override monitor for workspace 2 and 4 with eDP-2
hyprctl monitors | grep eDP-2 && \
	hyprctl --batch "keyword workspace 2,monitor:eDP-2 ; keyword workspace 4,monitor:eDP-2"

waybar_loop &
sleep 1 # wait for waybar

if rg -q "Ubuntu" /etc/os-release; then
	# Ubuntu
	flatpak run com.slack.Slack --enable-features=UseOzonePlatform --ozone-platform=wayland &
	~/.local/bin/postman --enable-features=UseOzonePlatform --ozone-platform=wayland &
else
	# Arch Linux
	XDG_CURRENT_DESKTOP=gnome /usr/bin/Telegram &
	firefox &
	hyprctl dispatch moveworkspacetomonitor 2 0
fi

nm-applet --indicator &
blueman-applet &

hyprctl dispatch workspace 1
