#!/bin/bash

SELECTED=$(find ~/Downloads/ -type f \
	\( -name '*.mp4' -o -name '*.mkv' \) \
	-not -path '*/Telegram Desktop/*' \
	| rofi -i -font "Droid Sans 16" \
	-theme Arc-Dark -dmenu \
	-dpi $QT_FONT_DPI)

[ -z "$SELECTED" ] || [ -e "$SELECTED" ] && mpv "$SELECTED" 
