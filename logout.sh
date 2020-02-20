#!/usr/bin/env zsh
# When user logout

# umount encrypted disk
umount /dev/mapper/homelib
sudo /usr/sbin/cryptdisks_stop homelib

