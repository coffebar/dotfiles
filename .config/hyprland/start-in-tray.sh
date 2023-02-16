#!/bin/sh
# start waybar and programs with tray icons after pause
waybar &
sleep 1
nm-applet --indicator &
crow &
syncthingtray --wait &
XDG_CURRENT_DESKTOP=gnome telegram-desktop &
