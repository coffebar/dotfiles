export TERMINAL=alacritty
export EDITOR=nvim

alias i="yay -Sy && yay -S"
alias dotf="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
alias v=$EDITOR
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep --color=never -P '(percentage|capacity|time|charge-)'"
alias md2pdf="~/mdtopdf.sh"
