#!/usr/bin/env bash
# start polybar for each monitor
# starting from the primary one

setup_hdmi1_2k() {
	# add monitor HDMI1 with "2560x1440_60.00" mode
	xrandr --newmode "2560x1440_60.00" 312.25 2560 2752 3024 3488 1440 1443 1448 1493 -hsync +vsync
	xrandr --addmode HDMI1 "2560x1440_60.00"
	xrandr --output HDMI1 --mode "2560x1440_60.00" --pos 0x0 \
		--output eDP1 --primary --mode 1920x1200 --pos 320x1440
}

setup_monitors() {
	local NEED_HDMI=0
	local NEED_NO_HDMI=0

	if xrandr | grep 'HDMI1 connected'; then
		setup_hdmi1_2k
		NEED_HDMI=1
	else
		# disable HDMI1, setup correct resolution and position
		xrandr --output HDMI1 --off \
			--output eDP1 --pos 0x0 --primary --mode 1920x1200 --pos 0x0
		NEED_NO_HDMI=1
	fi

	# wait until xrandr finished job
	if [ $NEED_HDMI -eq 1 ]; then
		until xrandr | grep 'HDMI1 connected'; do sleep 1; done
		dunstify -t 2000 "HDMI1 connected"
	fi
	if [ $NEED_NO_HDMI -eq 1 ]; then
		until xrandr | grep -v 'HDMI1 connected'; do sleep 1; done
	fi
}

start_polybar() {
	local BAR_NAME=default
	local PRIMARY
	local MONITOR
	local POLYBAR_CONF
	PRIMARY=$(polybar -m | grep primary | awk -F: '{print $1}')
	POLYBAR_CONF="$HOME/.config/$XDG_SESSION_OPT/polybar.ini"
	MONITOR=$PRIMARY polybar -c "$POLYBAR_CONF" --reload $BAR_NAME &
	sleep 3 # wait for tray
	for i in $(polybar -m | grep -v primary | awk -F: '{print $1}'); do
		MONITOR=$i polybar -c "$POLYBAR_CONF" --reload $BAR_NAME &
	done
}

killall polybar
setup_monitors
# wallpaper
feh --bg-scale ~/Pictures/wallpapers/bridge.jpg
start_polybar
