#!/bin/sh

# exit fullscreen from mpv before lock screen
/usr/bin/xdotool key \
	--clearmodifiers \
	--window "$(/usr/bin/xdotool search --onlyvisible --class mpv)" Escape

# locker
XSECURELOCK_COMPOSITE_OBSCURER=0 XSECURELOCK_SHOW_USERNAME=0 \
	XSECURELOCK_SHOW_HOSTNAME=0 XSECURELOCK_SHOW_DATETIME=1 \
	XSECURELOCK_PASSWORD_PROMPT=kaomoji xsecurelock
