#!/bin/sh
# start waybar and programs with tray icons after pause
waybar &
sleep 1
nm-applet --indicator &
crow &
syncthingtray --wait &
env QT_QPA_PLATFORM=xcb copyq &# copyq needs xwayland
XDG_CURRENT_DESKTOP=gnome telegram-desktop &
