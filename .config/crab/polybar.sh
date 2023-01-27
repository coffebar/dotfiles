#!/usr/bin/env bash
# start polybar for each monitor
# starting from the primary one

killall polybar && sleep 1

BAR_NAME=default

PRIMARY=$(polybar -m | grep primary | awk -F: '{print $1}')

POLYBAR_CONF="$HOME/.config/$XDG_SESSION_OPT/polybar.ini"
MONITOR=$PRIMARY polybar -c "$POLYBAR_CONF" --reload $BAR_NAME &

sleep 3

for i in $(polybar -m | grep -v primary | awk -F: '{print $1}'); do
    MONITOR=$i polybar -c "$POLYBAR_CONF" --reload $BAR_NAME &
done
