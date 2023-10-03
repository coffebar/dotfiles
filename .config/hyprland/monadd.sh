#!/bin/bash

MON2=HDMI-A-1

hyprctl monitors | grep $MON2 || exit

hyprctl dispatch moveworkspacetomonitor 1 $MON2
hyprctl dispatch moveworkspacetomonitor 3 $MON2
hyprctl dispatch workspace 1
