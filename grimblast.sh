#!/bin/zsh
TARGET="area"
if [[ "$1" == "screen" ]]; then
	TARGET=$1
fi
FNAME="/tmp/ksnip/$(date +'%s')/screenshot.png"
mkdir -p $(dirname "$FNAME")
grimblast --notify copysave $TARGET "$FNAME"
ksnip -e "$FNAME" &
