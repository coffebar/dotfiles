#!/bin/bash
# This script runs on press ALT+key


# Alt+$1 pressed
case "$1" in

# Moving windows to custom positions
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
  wmctrl -a 'Telegram' || telegram-desktop &
  ;;
  "c")
  # c - code editor
  wmctrl -a 'nVim Editor Session' && exit
  # define bare git repo to make work vim's git plugins
  export GIT_DIR=$HOME/dotfiles
  export GIT_WORK_TREE=$HOME

  alacritty -t "nVim Editor Session" \
      -e nvim -S $HOME/.config/nvim/configs-session.vim &
  ;;
  # More apps below
  "i")
  # i - IDE PhpStorm
  wmctrl -a ' PhpStorm' || GDK_SCALE='' $HOME/PhpStorm/bin/phpstorm.sh &
  i3-msg 'workspace 3, move workspace to output DP-0.8'
  i3-msg 'workspace 3'
  ;;
  "b")
  # b - browser
  wmctrl -a ' - Google Chrome' || chromium &
  i3-msg 'workspace 4, move workspace to output HDMI-0'
  i3-msg 'workspace 4'
  ;;
  "v")
  # v - connect or disconnect to VPN
  #VPN_UUID='cyber'
  #(nmcli connection show --active | grep --quiet "$VPN_UUID") && nmcli connection down "$VPN_UUID" || nmcli connection up "$VPN_UUID"
  WG_CONF="$HOME/Sync/Work/vpn/wg0-client-pc.conf"
  # note: add "abc ALL=(root) NOPASSWD:/usr/bin/wg-quick" to /etc/sudoers.d/wg
  if [ -f "$WG_CONF" ]; then
    sudo /usr/bin/wg-quick down $WG_CONF || sudo /usr/bin/wg-quick up $WG_CONF
  fi
  ;;
  "s")
  # s - Spotify
  wmctrl -a 'Spotify ' || /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=spotify --file-forwarding com.spotify.Client &
  ;;
esac
