#!/usr/bin/env zsh
# Startup applications - I prefer if all this in a single file

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
[ -e "/usr/bin/synapse" ] && /usr/bin/synapse --startup &

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
if grep '/dev/mapper/homelib' /etc/fstab; then
  sudo /usr/sbin/cryptdisks_start homelib
  mount /dev/mapper/homelib
fi

# Dropbox - sync files
/usr/bin/dropbox start -i &

# Start KeePassXC with unlocking password # see https://github.com/keepassxreboot/keepassxc/issues/1267
bash -c "secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin $HOME/Dropbox/lastpass.kdbx" &


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


# custom visualizations via conky (stored outside this repo)
[ -e "$HOME/desktop-utils.sh" ] && zsh "$HOME/desktop-utils.sh" &
