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
  wmctrl -a ' File Manager' || thunar
  wmctrl -a ' File Manager' -e '0,0,36,-1,-1'
  ;;
  "t")
  # t - Telegram
  wmctrl -a 'Telegram' || $HOME/Telegram/Telegram
  wmctrl -a 'Telegram' -e '0,3,762,-1,-1' 
  ;;
  "c")
  # c - code
  wmctrl -a ' vscode ' || code
  wmctrl -a ' vscode ' -e '0,1280,738,-1,-1'
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
  VPN_UUID='client94'
  (nmcli connection show --active | grep --quiet "$VPN_UUID") && nmcli connection down "$VPN_UUID" || nmcli connection up "$VPN_UUID"
  ;;
  "k")
  # k - open Google Keep web version
  wmctrl -a 'Google Keep' || google-chrome --app=https://keep.google.com/u/0/ --new-window
  ;;
esac
