#!/bin/bash
START_PATH=$HOME/Downloads
MOVIES=$(find "$START_PATH" -type f \
	\( -name '*.mp4' -o -name '*.mkv' \) \
	-not -path '*/Telegram Desktop/*' \
	-printf '%P|')
SELECTED=$(echo "$MOVIES" \
	| rofi -i -font "Droid Sans 16" \
	-theme Arc-Dark -dmenu \
	-dpi $QT_FONT_DPI -sep '|')
MOVIE="$START_PATH/$SELECTED" 
[ -f "$MOVIE" ] && mpv "$MOVIE"
