#!/usr/bin/sh
# Helpers menu

SELECTED=$(printf "1 Close all windows\n2 Bluetooth enable\n3 Bluetooth disable\n4 WIFI enable\n5 WIFI disable\n6 Colorpicker\n7 KeePassXC open database" \
	| ofi-menu -i --sort-order=alphabetical)
if [ -z "$SELECTED" ]; then exit 0; fi
NUM=$(echo "$SELECTED" | rg -oN '^\d+ ' | rg -oN '\d+')

if [ "$NUM" -eq 1 ]; then
	hyprctl clients -j | jq -r '.[]["address"]' | xargs -I{} hyprctl dispatch closewindow address:{}
fi
if [ "$NUM" -eq 2 ]; then bluetooth on; fi
if [ "$NUM" -eq 3 ]; then bluetooth off; fi
if [ "$NUM" -eq 4 ]; then wifi on; fi
if [ "$NUM" -eq 5 ]; then wifi off; fi
if [ "$NUM" -eq 6 ]; then hyprpicker --autocopy --no-fancy; fi
if [ "$NUM" -eq 7 ]; then
	secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin ~/KeePass/database.kdbx
fi
