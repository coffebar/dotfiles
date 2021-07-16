set -gx EDITOR nvim
set -U fish_greeting
set -gx TERMINAL alacritty

# nnn
set -gx NNN_BMS 'b:~/Bookmarks;D:~/Documents;h:~;d:~/Downloads/'
set -gx NNN_COLORS '3627'
set -gx NNN_FIFO /tmp/nnn.fifo
set -gx NNN_PLUG 'p:preview-tui;'

alias i="sudo apt install"
alias dotf="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
alias tb="nc termbin.com 9999"
alias n=nnn
# get selected files list from nnn 
alias ncp="cat $HOME/.config/nnn/.selection | tr '\0' '\n'"
