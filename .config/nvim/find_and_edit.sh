#!/bin/bash
# run (neo)vim to search and open a single file
GIT_DIR=$HOME/dotfiles GIT_WORK_TREE=$HOME $EDITOR -c 'bd! | SearchInHome' _
