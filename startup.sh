#!/usr/bin/env zsh
# Startup applications - I prefer if all this in a single file

# redirect output to files
exec 1>$HOME/startup.out.log
exec 2>$HOME/startup.err.log

# enable pulse-audio echo cancellation filter
#export PULSE_PROP="filter.want=echo-cancel"

# xbindkeys - keyboard bindings
/usr/bin/xbindkeys_autostart &

# keyboard modifications 
xmodmap "$HOME/.xmodmaprc"

# check day of week to choose programs to run
DAYOFWEEK=`/bin/date +%u`
DAYHOUR=`/bin/date +%H`

# conky - desktop widget
if [ -e "$HOME/.harmattan-themes/conky.sh" ]; then
  bash $HOME/.harmattan-themes/conky.sh &
fi


if [[ $DAYOFWEEK -lt 6 ]]; then
  # phpstorm IDE
  /bin/sh $HOME/PhpStorm/bin/phpstorm.sh &
  # chrome browser
  google-chrome &
fi

# firefox browser
firefox -new-instance -P default &
firefox -new-instance -P Work &

# xfce only
if [[ $XDG_CURRENT_DESKTOP == "XFCE" ]]; then

  # Shutter - capture and edit screenshots
  /usr/bin/shutter --min_at_startup &

  # Synapse launcher
  [ -e "/usr/bin/synapse" ] && /usr/bin/synapse --startup &

fi

# Telegram messenger
$HOME/Telegram/Telegram &

# script to extract zip files after download
/bin/bash "$HOME/Downloads/Telegram Desktop/unzip_here.sh" &

# mount encrypted disk
if grep '/dev/mapper/homelib' /etc/fstab; then
  sudo /usr/sbin/cryptdisks_start homelib
  mount /dev/mapper/homelib
fi

ulauncher --hide-window &

# Dropbox - sync files
#/usr/bin/dropbox start -i &

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


# move keepass app
move_app_to_workspace 'Lastpass' 1 &

# custom visualizations via conky (stored outside dotfiles repo)
[ -e "$HOME/desktop-utils.sh" ] && zsh "$HOME/desktop-utils.sh" &
