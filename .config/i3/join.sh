#!/bin/sh
COMMON_PART="$HOME/.config/i3/i3config.part"
cat $COMMON_PART "$HOME/.config/potato/i3config.part" > "$HOME/.config/potato/i3config"
cat $COMMON_PART "$HOME/.config/kindle/i3config.part" > "$HOME/.config/kindle/i3config"
