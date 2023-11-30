export TERMINAL=alacritty
export EDITOR=nvim

alias i="mkdir -p /tmp/yay; yay --diffmenu=false --builddir /tmp/yay -Sy && yay --builddir /tmp/yay  -S"
alias yy="mkdir -p /tmp/yay; yay --diffmenu=false --editmenu=false --confirm=false --builddir /tmp/yay -Syu"
alias dotf="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
alias v=$EDITOR
alias batt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep --color=never -P '(percentage|capacity|time|charge-)'"
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
