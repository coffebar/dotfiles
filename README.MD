My dotfiles backup for Arch setup.


![screenshot](https://raw.githubusercontent.com/Hukuta/dotfiles/master/screenshot.png)


Requirements listed in pkglist.txt

## Restore backup:
## Please don't do this without understanding all files and commands! It may harm your system.
```
git clone --depth=1 https://github.com/Hukuta/dotfiles.git dotfiles_tmp
rsync -rv --exclude '.git' --exclude 'README.MD' --exclude '.gitignore' ./dotfiles_tmp/ ./ 

rm -rf ./dotfiles_tmp/

sudo pacman -S --needed - < pkglist.txt
```
