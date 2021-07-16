#!/usr/bin/env zsh
# Startup applications - I prefer if all this in a single file

# redirect output to files
exec 1>$HOME/startup.out.log
exec 2>$HOME/startup.err.log

# enable pulse-audio echo cancellation filter
#export PULSE_PROP="filter.want=echo-cancel"

# keyboard modifications (swap keys)
/bin/bash -c "sleep 5 && /usr/bin/xmodmap $HOME/.xmodmaprc"

# check day of week to choose programs to run
DAYOFWEEK=`/bin/date +%u`
DAYHOUR=`/bin/date +%H`

# xfce only
if [[ $XDG_CURRENT_DESKTOP == "XFCE" ]]; then

  /usr/bin/xbindkeys_autostart &

  if [[ $DAYOFWEEK -lt 6 ]]; then
    # phpstorm IDE
    /bin/sh $HOME/PhpStorm/bin/phpstorm.sh &
    # chrome browser
    /usr/bin/google-chrome &
  fi

  # conky - desktop widget
  if [ -e "$HOME/.harmattan-themes/conky.sh" ]; then
    /bin/bash $HOME/.harmattan-themes/conky.sh &
  fi

  # custom visualizations via conky (stored outside dotfiles repo)
  [ -e "$HOME/desktop-utils.sh" ] && zsh "$HOME/desktop-utils.sh" &

  # firefox browser
  /usr/bin/firefox -new-instance -P default &
  /usr/bin/firefox -new-instance -P Work &


  /usr/bin/ulauncher --hide-window &
fi


# script to extract zip files after download
/bin/bash "$HOME/Downloads/Telegram Desktop/unzip_here.sh" &

# mount encrypted disk
if grep '/dev/mapper/homelib' /etc/fstab; then
  sudo /usr/sbin/cryptdisks_start homelib
  mount /dev/mapper/homelib
fi


# Telegram messenger
telegram-desktop &
# Dropbox - sync files
/usr/bin/dropbox start -i &

# Start KeePassXC with unlocking password # see https://github.com/keepassxreboot/keepassxc/issues/1267
/bin/bash -c "secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin $HOME/Dropbox/lastpass.kdbx" &
# remove "urgency" from KeePassXC on startup
/bin/bash -c 'sleep 5 && wmctrl -r KeePassXC -b remove,demands_attention' &

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


if [[ $XDG_CURRENT_DESKTOP == "XFCE" ]]; then
  # move keepass app
  move_app_to_workspace 'Lastpass' 1 &
fi

# backup home directory
[ -e /bin/backup-abc-toshiba-start.sh ] && sudo /bin/bash /bin/backup-abc-toshiba-start.sh &
