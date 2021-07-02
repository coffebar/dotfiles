#!/usr/bin/env bash

# This script runs on press ALT+key from $HOME/.xbindkeysrc

# Alt+$1 pressed
case "$1" in

# Moving windows to custom positions
# F - Files, T - Telegram, C - code (vs code)
#  _____
# |__F__|_____
# |__T__|__C__|
#
  "f")
  # f - Thunar File Manager
  wmctrl -a 'Ranger File Manager' || $HOME/.cargo/bin/alacritty -t 'Ranger File Manager' -e ranger $HOME/Bookmarks/
  #wmctrl -a ' File Manager' -e '0,0,36,-1,-1'
  ;;
  "t")
  # t - Telegram
  wmctrl -a 'Telegram' || $HOME/Telegram/Telegram
  #wmctrl -a 'Telegram' -e '0,3,762,-1,-1'
  ;;
  "c")
  # c - editor
  wmctrl -a 'Vim Editor Session' || "$HOME/.cargo/bin/alacritty" -t "Vim Editor Session" \
      -e /usr/bin/vim -S "$HOME/configs.edit.session.vim"
  ;;
  # More apps below
  "i")
  # i - IDE PhpStorm
  wmctrl -a ' PhpStorm' || $HOME/PhpStorm/bin/phpstorm.sh
  ;;
  "b")
  # b - browser
  wmctrl -a ' - Google Chrome' || google-chrome
  ;;
  "y")
  # y - open youtube in new tab
  google-chrome https://www.youtube.com/
  ;;
  "v")
  # v - connect or disconnect to VPN
  VPN_UUID='cyber'
  (nmcli connection show --active | grep --quiet "$VPN_UUID") && nmcli connection down "$VPN_UUID" || nmcli connection up "$VPN_UUID"
  ;;
  "k")
  # k - open Google Keep web version
  wmctrl -a 'Google Keep' || google-chrome --app=https://keep.google.com/u/0/ --new-window
  ;;
  "p")
  # p - Play/Pause gmusicbrowser
  dbus-send --dest=org.gmusicbrowser /org/gmusicbrowser org.gmusicbrowser.RunCommand string:PlayPause
  ;;
  "s")
  # s - Spotify
  wmctrl -a 'Spotify ' || /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=spotify --file-forwarding com.spotify.Client
  ;;
  "r")
  # r - restart xfce panel
  xfce4-panel -r
  ;;
esac
