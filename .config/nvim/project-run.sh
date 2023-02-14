#!/bin/bash

# looking for *.sh files in project
SCRIPTS=$(rg --max-depth=2 --hidden --files --glob '*.sh')
if [ -z "$SCRIPTS" ]; then exit; fi
# give to select one
if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	SELECTED=$(echo "$SCRIPTS" | wofi --show dmenu)
else
	SELECTED=$(echo "$SCRIPTS" | rofi -i -theme Arc-Dark -dmenu -dpi "$QT_FONT_DPI")
fi
# execute that file in bash
[ -n "$SELECTED" ] && [ -f "$SELECTED" ] && source "$SELECTED"
