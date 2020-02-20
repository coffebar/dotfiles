#!/usr/bin/env zsh
# Startup applications
# - I prefer if all this in a single file

# redirect output to files
exec 1>$HOME/startup.out.log
exec 2>$HOME/startup.err.log

# xbindkeys - keyboard bindings
/usr/bin/xbindkeys_autostart &

# conky - desktop widget
bash $HOME/.harmattan-themes/conky.sh &

# phpstorm IDE
/bin/sh $HOME/PhpStorm/bin/phpstorm.sh &

# chrome browser
google-chrome &

# Shutter - capture and edit screenshots
/usr/bin/shutter --min_at_startup &

# Synapse launcher
/usr/bin/synapse --startup &

# Telegram messenger
$HOME/Telegram/Telegram &

# script to extract zip files after download
/bin/bash "$HOME/Downloads/Telegram Desktop/unzip_here.sh" &

# Ctrl+` to open terminal Tilda
/usr/bin/tilda --hidden --working-dir="$HOME/Downloads" \
  --config-file="$HOME/.config/tilda/config_0" &

# VS Code
/usr/bin/code &

# Thunar - file manager
thunar &

# mount encrypted disk
sudo /usr/sbin/cryptdisks_start homelib
mount /dev/mapper/homelib

# Rhythmbox - music player
rhythmbox &

# Dropbox - sync files
dropbox start -i &


# moving windows by workspaces
function move_app_to_workspace() {
  # wait up to 40 sec until wmctrl find window
  for i in {1..20}; do wmctrl -r $1 -t $2 && grep "$2 $(hostname) $1" && break || sleep 2; done
  # debug echo
  echo "$1 -> $2"
}

move_app_to_workspace ' File Manager' 1 &
move_app_to_workspace 'Telegram' 1 &

move_app_to_workspace 'Welcome to PhpStorm' 2 &

move_app_to_workspace 'rhythmbox' 3 &


# run backup
if [ -e "$HOME/backup-server.sh" ]; then
  "$HOME/backup-server.sh" > "$HOME/Downloads/serv.bkp.log" 2>&1
fi


wmctrl -l
