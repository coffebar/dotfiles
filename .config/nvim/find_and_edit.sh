#!/bin/bash
# run [Neo]vim to search and open some file
if [ -z $EDITOR ] || ! [[ $EDITOR == *"vim" ]]; then
	EDITOR=nvim
fi
if [ -d $HOME/dotfiles ]; then
	GIT_DIR=$HOME/dotfiles GIT_WORK_TREE=$HOME \
		$EDITOR -c 'bd! | SearchInHome' _
else
	$EDITOR -c 'bd! | SearchInHome' _
fi
