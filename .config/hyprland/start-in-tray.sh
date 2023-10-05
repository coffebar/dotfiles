#!/bin/sh
# start waybar and programs with tray icons after pause

waybar_loop() {
	# restart waybar on crash (after suspend mode)
	WAYBAR_RESTARTS=0
	while [ $WAYBAR_RESTARTS != 6 ]; do # limited to 5 restars
		waybar
		let WAYBAR_RESTARTS++
		notify-send -a "start-in-tray.sh" "Waybar crashed!"
		sleep 1
	done
}

# wait for xdg-desktop-portal-hyprland to start
until pgrep -f 'xdg-desktop-portal-hyprland'; do sleep 2; done


waybar_loop &
firefox &

sleep 1 # wait for waybar

nm-applet --indicator &
crow &
syncthingtray --wait &
XDG_CURRENT_DESKTOP=gnome telegram-desktop &
blueman-applet &

hyprctl dispatch workspace 1
