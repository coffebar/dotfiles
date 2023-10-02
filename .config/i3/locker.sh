#!/bin/sh

# exit fullscreen from mpv before lock screen
/usr/bin/xdotool key \
	--clearmodifiers \
	--window "$(/usr/bin/xdotool search --onlyvisible --class mpv)" Escape

# sleep
if [ "$1" = "sleep" ]; then
	systemctl suspend &
fi

# stop compositing
killall xcompmgr &
# locker
XSECURELOCK_COMPOSITE_OBSCURER=0 XSECURELOCK_SHOW_USERNAME=0 \
	XSECURELOCK_SHOW_HOSTNAME=0 XSECURELOCK_SHOW_DATETIME=1 \
	XSECURELOCK_PASSWORD_PROMPT=kaomoji xsecurelock \
	&& xcompmgr -n & # restart compositing

# refresh current workspace after compositing restart
sleep 0.3
i3-msg workspace 9 && i3-msg workspace 9
