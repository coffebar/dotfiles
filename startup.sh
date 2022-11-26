#!/usr/bin/env zsh

# redirect output to files
exec 1>$HOME/startup.out.log
exec 2>$HOME/startup.err.log

# check day of week to choose programs to run
DAYOFWEEK=`/bin/date +%u`
DAYHOUR=`/bin/date +%H`

# script to extract zip files after download
/bin/bash "$HOME/Downloads/Telegram Desktop/unzip_here.sh" &

# Telegram messenger
telegram-desktop &

# Start KeePassXC with unlocking password # see https://github.com/keepassxreboot/keepassxc/issues/1267
/bin/bash -c "secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin $HOME/Sync/Work/lastpass.kdbx" &
# remove "urgency" from KeePassXC on startup
/bin/bash -c 'sleep 5 && wmctrl -r KeePassXC -b remove,demands_attention' &


