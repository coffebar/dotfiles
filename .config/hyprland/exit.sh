#!/bin/sh
# exit hyprland with force

echo "Hyprland exit" | systemd-cat -t coffebar -p info
hyprctl dispatch exit &

sleep 360
echo "Hyprland failed to exit" | systemd-cat -t coffebar -p err
killall -9 Hyprland
