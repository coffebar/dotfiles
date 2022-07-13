#!/bin/bash
# Script to setup dock workflow as root
# and return back to default if need.
# Runing from /etc/lightdm/greeter-setup.sh

if xrandr --listmonitors | grep 'DP-1.1.8 2560' ; then
  cat /home/abc/environment2k > /etc/environment
  #nmcli radio wifi off
else
  cat /home/abc/environment4k > /etc/environment
  #nmcli radio wifi on
fi

