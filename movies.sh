#!/bin/bash
START_PATH=$HOME/Downloads
SELECTED=$(find "$START_PATH" -type f \
	\( -name '*.mp4' -o -name '*.mkv' \) \
	-not -path '*/Telegram Desktop/*' \
	-size +100M \
	-printf '%P|' \
	| rofi -i -font "Droid Sans 16" \
	-theme Arc-Dark -dmenu \
	-dpi $QT_FONT_DPI -sep '|')
MOVIE="$START_PATH/$SELECTED" 
if [ -f "$MOVIE" ]; then
	killall mpv
	mpv \
	-alang="ukr,uk,eng,en" -slang="eng,en,ukr,uk" \
	--fullscreen "$MOVIE"
fi
