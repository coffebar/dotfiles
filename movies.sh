#!/bin/bash
START_PATH=$HOME/Downloads

if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	RG_OUTPUT=$(rg --files --max-depth=3 -N \
		--iglob '*.mp4' --iglob '*.mkv' --iglob '*.avi' \
		--glob '!*Telegram Desktop*' \
		"$START_PATH")
	SELECTED=$(echo "$RG_OUTPUT" | sed "s+$START_PATH/++g" | wofi --show dmenu)
else
	SELECTED=$(find "$START_PATH" -type f \
	\( -name '*.mp4' -o -name '*.mkv' -o -name '*.avi' \) \
	-not -path '*/Telegram Desktop/*' \
	-size +100M \
	-printf '%P|' \
	| rofi -i -font "Droid Sans 16" \
	-theme Arc-Dark -dmenu \
	-dpi $QT_FONT_DPI -sep '|')
fi

MOVIE="$START_PATH/$SELECTED" 
if [ -f "$MOVIE" ]; then
	killall mpv
	mpv \
	-alang="ukr,uk,eng,en" -slang="eng,en,ukr,uk" \
	--fullscreen "$MOVIE"
fi
