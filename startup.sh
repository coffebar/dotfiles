#!/usr/bin/env zsh
# Startup applications
# - I prefer if all this in a single file

# redirect output to files
exec 1>$HOME/startup.out.log
exec 2>$HOME/startup.err.log

# enable pulse-audio echo cancellation filter
#export PULSE_PROP="filter.want=echo-cancel"

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

# firefox browser
firefox -new-instance -P default &
firefox -new-instance -P Work &

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
thunar "$HOME/Downloads" &

# mount encrypted disk
sudo /usr/sbin/cryptdisks_start homelib
mount /dev/mapper/homelib

# Dropbox - sync files
dropbox start -i &

# Start KeePassXC with unlocking password # see https://github.com/keepassxreboot/keepassxc/issues/1267
bash -c "secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin $HOME/Dropbox/lastpass.kdbx" &

# Error Report from the server
#[[ $DAYOFWEEK -lt 6 && $DAYHOUR -lt 19 ]] && zenity --title="Tabs API Error Report" \
#  --text="`ssh searches /home/search/feed-err.sh`" --width=300 --info &


# moving windows by workspaces
function move_app_to_workspace() {
  # wait up to 40 sec until wmctrl find window
  for i in {1..20}; do 
    MATCHES=$(wmctrl -l | grep "$1")
    if [[ $MATCHES ]]; then
        echo $MATCHES | awk '{ print $1 }' | xargs -I % wmctrl -i -r "%" -t $2
        break
    else
        sleep 2
    fi
  done
  # debug echo
  echo "$1 -> $2"
}

move_app_to_workspace ' File Manager' 1 &
move_app_to_workspace 'Telegram' 1 &
move_app_to_workspace 'Lastpass' 2 &
#move_app_to_workspace 'Mozilla Firefox' 2 &
#move_app_to_workspace ' Google Chrome' 2 &


#[[ $DAYOFWEEK -lt 6 ]] && move_app_to_workspace 'Welcome to PhpStorm' 2 &

# custom visualizations via conky (stored outside this repo)
[ -e "$HOME/desktop-utils.sh" ] && zsh "$HOME/desktop-utils.sh" &

# make backups only once per day (backup-server.sh is stored outside this repo)
#if [ -e "$HOME/backup-server.sh" ]; then # check if script exists 
  # check if last backup was made not today
#  today_date=$(date +%Y-%m-%d)
#  last_date_cmd=$(ls -l --full-time "$HOME/Downloads/serv.bkp.log" | egrep -c $today_date)
#  if [[ $last_date_cmd -lt 1 ]]; then
    # run backup
#    "$HOME/backup-server.sh" > "$HOME/Downloads/serv.bkp.log" 2>&1
#  fi
#fi


#bash $HOME/lamp-xiaomi/start-server.sh &

bash $HOME/Documents/phpProjects/spreadsheets-bot/start.sh

# Monitor home devices online
#$HOME/.cargo/bin/alacritty -d 60 30 -t 'Online' --working-directory "$HOME/router-mon" --no-live-config-reload -e node router-devices.js &
