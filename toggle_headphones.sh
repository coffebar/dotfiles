#!/bin/bash
# switch between first 2 audio output devices

DEFAULT_SINK_NAME=$(pactl info | grep -P '^Default Sink: (.*)$' | awk '{print $3}')
OTHER_SINK=$(pactl list short sinks | grep --invert-match "$DEFAULT_SINK_NAME" | head -1)
OTHER_SINK_ID=$(echo $OTHER_SINK | awk '{print $1}')
OTHER_SINK_NAME=$(echo $OTHER_SINK | awk '{print $2}')

echo "$OTHER_SINK_ID $OTHER_SINK_NAME"

IS_HDMI=$(echo "$OTHER_SINK_NAME" | grep hdmi)
#if [[ $IS_HDMI ]]; then
#  pacmd set-sink-volume $OTHER_SINK_ID 50000
#else
#  pacmd set-sink-volume $OTHER_SINK_ID 30000
#fi

pactl set-default-sink $OTHER_SINK_ID

notify-send "Audio Device" "$OTHER_SINK_NAME" --expire-time=1500

