#!/bin/bash
# find file in the home folder using fzf with preview and open it in nvim to edit

PREVIEW='bat --style=numbers --color=always --line-range :500 {}'

export GIT_DIR=$HOME/dotfiles
export GIT_WORK_TREE=$HOME
FNAME=$(~/.config/nvim/find_to_edit.sh | fzf --preview "$PREVIEW")
echo "Opening $FNAME"
[ -f "$FNAME" ] && nvim "$FNAME"

