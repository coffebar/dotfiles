killall polybar

PROF=$(autorandr --current)
if [ -z $PROF ] && ! [ -z $1 ]; then
	# try harder to find profile if script called with any arg 
    PROF=$(autorandr | grep '(detected)')
	echo $1
fi
if [ -z $PROF ]; then
    exit 0
fi
if [[ $PROF == *'dock'* ]]; then
    FIRST_MONITOR=$(polybar -m | grep "+0+0" | awk -F: '{print $1}')
    SECOND_MONITOR=$(polybar -m | grep -v "+0+0" | awk -F: '{print $1}')
		CONF=~/.config/potato/polybar2k.ini

    MONITOR=$SECOND_MONITOR polybar --config=$CONF --reload first &
    sleep 3
    MONITOR=$FIRST_MONITOR polybar --config=$CONF --reload second &
else
    polybar --reload --config=~/.config/potato/polybar.ini example &
fi

