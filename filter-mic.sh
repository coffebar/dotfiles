#!/bin/bash

sleep 5
SOURCE_NAME=$(pactl list short sources | grep filter-chain | head -1 | awk '{print $2}')
[ -z "$SOURCE_NAME" ] || pactl set-default-source $SOURCE_NAME

