#!/usr/bin/env zsh
# When user logout

# exit chrome session
bash $HOME/ctrl_q.sh &

# umount encrypted disk
umount /dev/mapper/homelib
sudo /usr/sbin/cryptdisks_stop homelib

