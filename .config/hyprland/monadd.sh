#!/bin/bash

MON2=HDMI-A-1

hyprctl monitors | grep $MON2 || exit

hyprctl dispatch moveworkspacetomonitor 1 $MON2
hyprctl dispatch moveworkspacetomonitor 3 $MON2
hyprctl dispatch workspace 1

# switch audio output to speakers
ALT_SINK=$(pactl list short sinks | tail -2 | head -1 | awk '{print $1}')
pactl set-default-sink "$ALT_SINK"
notify-send "Audio Device" "switched from monadd.sh" --expire-time=1500
