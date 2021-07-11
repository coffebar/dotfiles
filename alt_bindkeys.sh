#!/bin/bash
# This script runs on press ALT+key from $HOME/.xbindkeysrc

# add aliases if not loaded
[ -f ~/.bash_aliases ] && [ -z "$NNN_BMS" ] && source ~/.bash_aliases


# Alt+$1 pressed
case "$1" in

# Moving windows to custom positions
# F - Files, T - Telegram, C - code editor (vim)
#
  "f")
  # f - File Manager
  # open directory from clipboard if exists
  BUFF=$(xclip -selection c -o)
  FM=thunar
  if [ -f "$BUFF" ]; then
      D=$(dirname "$BUFF")
      $FM "$D" &
      exit
  fi
  if [ -d "$BUFF" ]; then
      $FM "$BUFF" &
      exit
  fi
  $FM $HOME/Downloads &
  ;;
  "t")
  # t - Telegram
  wmctrl -a 'Telegram' || $HOME/Telegram/Telegram &
  ;;
  "c")
  # c - editor
  wmctrl -a 'Vim Editor Session' || alacritty -t "Vim Editor Session" \
      -e /usr/bin/vim -S "$HOME/configs.edit.session.vim" &
  ;;
  # More apps below
  "i")
  # i - IDE PhpStorm
  wmctrl -a ' PhpStorm' || $HOME/PhpStorm/bin/phpstorm.sh &
  i3-msg 'workspace 3, move workspace to output DP-0.8'
  i3-msg 'workspace 3'
  ;;
  "b")
  # b - browser
  wmctrl -a ' - Google Chrome' || google-chrome &
  i3-msg 'workspace 4, move workspace to output primary'
  i3-msg 'workspace 4'
  ;;
  "y")
  # removed
  ;;
  "v")
  # v - connect or disconnect to VPN
  VPN_UUID='cyber'
  (nmcli connection show --active | grep --quiet "$VPN_UUID") && nmcli connection down "$VPN_UUID" || nmcli connection up "$VPN_UUID"
  ;;
  "k")
  # removed
  ;;
  "s")
  # s - Spotify
  wmctrl -a 'Spotify ' || /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=spotify --file-forwarding com.spotify.Client &
  ;;
esac
