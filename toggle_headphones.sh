#!/bin/bash
# switch between first 2 audio output devices

DEFAULT_SINK_NAME=$(pactl get-default-sink)
OTHER_SINK=$(pactl list short sinks | grep --invert-match "$DEFAULT_SINK_NAME" | tail -1)
OTHER_SINK_ID=$(echo $OTHER_SINK | awk '{print $1}')
OTHER_SINK_NAME=$(echo $OTHER_SINK | awk '{print $2}')

pactl set-default-sink $OTHER_SINK_ID

notify-send "Audio Device" "$OTHER_SINK_NAME" --expire-time=1500

