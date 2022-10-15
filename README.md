My .dotfiles backup for Arch setup.


![Screenshot](https://raw.githubusercontent.com/Hukuta/dotfiles/master/screenshot.png)


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

```

Neovim plugins and dependencies
```
npm i -g pyright bash-language-server \
  vscode-langservers-extracted \
  typescript typescript-language-server \
  @tailwindcss/language-server \
  eslint
yay -Sy ltex-ls-bin rust-analyzer phpactor lua-language-server
nvim -c PackerSync # packer is installed via yay
nvim -c 'TSInstall css python php rust javascript sql toml typescript go yaml dockerfile scss html bash json lua c kotlin markdown'
```

This [neovim](https://github.com/neovim/neovim) setup supports syntax highlighting and code completion for following languages: 

- bash
- css
- html 
- javascript
- lua
- php
- python
- rust 
- typescript

