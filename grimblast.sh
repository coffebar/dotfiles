#!/bin/zsh
TARGET="area"
if [[ "$1" == "screen" ]]; then
	TARGET=$1
fi
# filename available in the /tmp (without timezone leek)
FNAME=$(python -c "import os
num = 1
dir = '/tmp/ksnip/screenshot-'
while os.path.exists(dir + str(num) + '.png'):
	num += 1
print(dir + str(num) + '.png')")
mkdir -p $(dirname "$FNAME")
# put filename to the clipboard history
wl-copy "$FNAME"
# take screenshot and copy image data to clipboard
grimblast --notify copysave $TARGET "$FNAME"
# add a file to ksnip history to edit it
ksnip -e "$FNAME" &
