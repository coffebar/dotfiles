#!/usr/bin/env bash
# start polybar for each monitor
# starting from the primary one

BAR_NAME=example

PRIMARY=$(polybar -m | grep primary | awk -F: '{print $1}')

MONITOR=$PRIMARY polybar --reload $BAR_NAME &

sleep 1

for i in $(polybar -m | grep -v primary | awk -F: '{print $1}'); do
    MONITOR=$i polybar --reload $BAR_NAME &
done
