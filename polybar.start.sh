#!/usr/bin/env bash
# start polybar for each monitor
# starting from the left

if [ $(polybar -m | wc -l) == 1 ]; then
    polybar --reload example &
else
    FIRST_MONITOR=$(polybar -m | grep "+0+0" | awk -F: '{print $1}')
    SECOND_MONITOR=$(polybar -m | grep -v "+0+0" | awk -F: '{print $1}')

    MONITOR=$SECOND_MONITOR polybar --reload second &
    sleep 3
    MONITOR=$FIRST_MONITOR polybar --reload example &
fi
