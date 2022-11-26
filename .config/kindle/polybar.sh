#!/usr/bin/env bash
# start polybar for each monitor
# starting from the primary one

killall polybar && sleep 1

BAR_NAME=example

PRIMARY=$(polybar -m | grep primary | awk -F: '{print $1}')

MONITOR=$PRIMARY polybar -c $HOME/.config/kindle/polybar --reload $BAR_NAME &

sleep 3

for i in $(polybar -m | grep -v primary | awk -F: '{print $1}'); do
    MONITOR=$i polybar -c $HOME/.config/kindle/polybar --reload $BAR_NAME &
done
