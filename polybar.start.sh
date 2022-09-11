#!/usr/bin/env bash
# start polybar for each monitor
# starting from the left

killall polybar

PROF=$(autorandr --current)
if [ -z $PROF ]; then
    exit 0
fi
if [[ $PROF == *'dock'* ]]; then
    FIRST_MONITOR=$(polybar -m | grep "+0+0" | awk -F: '{print $1}')
    SECOND_MONITOR=$(polybar -m | grep -v "+0+0" | awk -F: '{print $1}')

    MONITOR=$SECOND_MONITOR polybar --config=~/.config/polybar/config2k.ini --reload first &
    sleep 3
    MONITOR=$FIRST_MONITOR polybar --config=~/.config/polybar/config2k.ini --reload second &
else
    polybar --reload example &
fi

