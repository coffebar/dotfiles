My dotfiles backup for Arch setup.


![screenshot](https://raw.githubusercontent.com/Hukuta/dotfiles/master/screenshot.png)


Requirements listed in pkglist.txt

## Restore backup:
## Please don't do this without understanding all files and commands! It may harm your system.
```
git clone --depth=1 https://github.com/Hukuta/dotfiles.git dotfiles_tmp
rsync -rv --exclude '.git' --exclude 'README.MD' --exclude '.gitignore' ./dotfiles_tmp/ ./ 

rm -rf ./dotfiles_tmp/

# install yay
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
yay -Y --gendb

# install packages
yay -S --needed - < pkglist.txt

# install ohmyzsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# visit vim and run :PlugInstall

```
