#!/bin/sh
# start waybar and programs with tray icons after pause
waybar &
sleep 1
nm-applet --indicator &
crow &
syncthingtray --wait &
QT_QPA_PLATFORM=xcb copyq &
XDG_CURRENT_DESKTOP=gnome telegram-desktop &
