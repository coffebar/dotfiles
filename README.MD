My dotfiles backup.

## Requirements:

- alacritty
- amixer
- bash
- dunst
- feh
- fish
- git
- i3-gaps
- i3lock
- nm-applet
- numlockx
- picom
- polybar
- ranger
- rsync
- setxkbmap
- telegram
- ttf font 'JetBrains Mono'
- ueberzug # pip3 install ueberzug
- wmctrl
- xautomation
- xclip
- xmodmap
- xrandr
- xss-lock
- xxkb
- zsh
- ~~ulauncher~~ krunner

## Restore backup:
## Please don't do this without understanding all files and commands! It may harm your system.
```
git clone --depth=1 https://github.com/Hukuta/dotfiles.git dotfiles_tmp
rsync -rv --exclude '.git' --exclude 'README.MD' --exclude '.gitignore' ./dotfiles_tmp/ ./ 
rm -rf ./dotfiles_tmp/
```
