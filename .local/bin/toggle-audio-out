#!/bin/bash
# switch between first 2 audio output devices

# get the default sink name
DEFAULT_SINK_NAME=$(pactl get-default-sink)
# get the other sink id and name
OTHER_SINK=$(pactl list short sinks | grep --invert-match "$DEFAULT_SINK_NAME" | tail -1)
OTHER_SINK_ID=$(echo "$OTHER_SINK" | awk '{print $1}')
OTHER_SINK_NAME=$(echo "$OTHER_SINK" | awk '{print $2}')

# set the default sink to the other sink
pactl set-default-sink "$OTHER_SINK_ID"

# notify the user of the change
notify-send "Audio Device" "$OTHER_SINK_NAME" --expire-time=1500
