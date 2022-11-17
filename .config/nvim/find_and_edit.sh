#!/bin/bash
# run [Neo]vim to search and open some file
GIT_DIR=$HOME/dotfiles GIT_WORK_TREE=$HOME \
	$EDITOR -c 'bd! | SearchInHome' _
