#!/usr/bin/sh
# Helpers menu

SELECTED=$(printf "1 Close all windows\n2 Bluetooth enable\n3 Bluetooth disable\n4 WIFI enable\n5 WIFI disable\n6 Colorpicker\n7 KeePassXC open database" | ofi-menu -i)
if [ -z "$SELECTED" ]; then
	exit 0
fi
if echo "$SELECTED" | rg '^1 '; then
	# Close all windows
	hyprctl clients -j | jq -r '.[]["address"]' | xargs -I{} hyprctl dispatch closewindow address:{}
fi
if echo "$SELECTED" | rg '^2 '; then
	bluetooth on
fi
if echo "$SELECTED" | rg '^3 '; then
	bluetooth off
fi
if echo "$SELECTED" | rg '^4 '; then
	wifi on
fi
if echo "$SELECTED" | rg '^5 '; then
	wifi off
fi
if echo "$SELECTED" | rg '^6 '; then
	hyprpicker --autocopy --no-fancy
fi
if echo "$SELECTED" | rg '^7 '; then
	secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin ~/KeePass/database.kdbx
fi
