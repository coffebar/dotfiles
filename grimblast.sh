#!/bin/zsh

FNAME="/tmp/ksnip/$(date +'%s')/screenshot.png"
mkdir -p $(dirname "$FNAME")
grimblast --notify copysave area "$FNAME"
ksnip -e "$FNAME" &
