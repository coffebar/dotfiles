#!/bin/bash
sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
echo "Starting xdg-desktop-portal-hyprland" >> xdg-desktop-portal-hyprland.log
/usr/lib/xdg-desktop-portal-hyprland >> xdg-desktop-portal-hyprland.log 2>&1 &
sleep 2
/usr/lib/xdg-desktop-portal &
