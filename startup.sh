#!/usr/bin/env zsh
# Startup applications
# - I prefer if all this in a single file

# redirect output to files
exec 1>$HOME/startup.out.log
exec 2>$HOME/startup.err.log

# xbindkeys - keyboard bindings
/usr/bin/xbindkeys_autostart &

# check day of week to choose programs to run
DAYOFWEEK=`/bin/date +%u`
DAYHOUR=`/bin/date +%H`

# conky - desktop widget
if [ -e "$HOME/.harmattan-themes/conky.sh" ]; then
  bash $HOME/.harmattan-themes/conky.sh &
fi

# phpstorm IDE
[[ $DAYOFWEEK -lt 6 ]] && /bin/sh $HOME/PhpStorm/bin/phpstorm.sh &

# chrome browser
google-chrome &

# Shutter - capture and edit screenshots
/usr/bin/shutter --min_at_startup &

# Synapse launcher
/usr/bin/synapse --startup &

# Telegram messenger
$HOME/Telegram/Telegram &

# script to extract zip files after download
[[ $DAYOFWEEK -lt 6 ]] && /bin/bash "$HOME/Downloads/Telegram Desktop/unzip_here.sh" &

# Ctrl+` to open terminal Tilda
/usr/bin/tilda --hidden --working-dir="$HOME/Downloads" \
  --config-file="$HOME/.config/tilda/config_0" &

# VS Code
[[ $DAYOFWEEK -lt 6 ]] && /usr/bin/code &

# Thunar - file manager
thunar "$HOME/Downloads" &

# mount encrypted disk
sudo /usr/sbin/cryptdisks_start homelib
mount /dev/mapper/homelib

# Rhythmbox - music player
rhythmbox &

# Dropbox - sync files
dropbox start -i &

# Error Report from the server
[[ $DAYOFWEEK -lt 6 && $DAYHOUR -lt 19 ]] && zenity --title="Tabs API Error Report" \
  --text="`ssh tabs /home/tabs/feed-err.sh`" --width=300 --info &


# moving windows by workspaces
function move_app_to_workspace() {
  # wait up to 40 sec until wmctrl find window
  for i in {1..20}; do wmctrl -r $1 -t $2 && grep "$2 $(hostname) $1" && break || sleep 2; done
  # debug echo
  echo "$1 -> $2"
}

move_app_to_workspace ' File Manager' 1 &
move_app_to_workspace 'Telegram' 1 &

[[ $DAYOFWEEK -lt 6 ]] && move_app_to_workspace 'Welcome to PhpStorm' 2 &

move_app_to_workspace 'rhythmbox' 3 &

# custom visualizations via conky (stored outside this repo)
[ -e "$HOME/desktop-utils.sh" ] && zsh "$HOME/desktop-utils.sh" &

# make backups only once per day (backup-server.sh is stored outside this repo)
if [ -e "$HOME/backup-server.sh" ]; then # check if script exists 
  # check if last backup was made not today
  today_date=$(date +%Y-%m-%d)
  last_date_cmd=$(ls -l --full-time "$HOME/Downloads/serv.bkp.log" | egrep -c $today_date)
  if [[ $last_date_cmd -lt 1 ]]; then
    # run backup
    "$HOME/backup-server.sh" > "$HOME/Downloads/serv.bkp.log" 2>&1
  fi
fi
