My .dotfiles backup for Arch setup.


![Screenshot](https://raw.githubusercontent.com/coffebar/dotfiles/master/screenshot.png)


Requirements listed in pkglist.txt

## Interesting features

- Some of wm's binds improved by lua script. Lua has more flexibility than i3config syntax. It is a good practice to automatically switch to the appropriate workspace after opening programs using a keyboard shortcut.

- ``Alt + f`` open a file manager in that directory what was found in clipboard. For example, if you copied a file from some program, you can open it's directory just by pressing this shortcut.

- ``Super + ` `` open ssh servers menu to connect.

- ``Super + \ `` open fuzzy finder to search for local text files in the home directory to edit in NeoVim.

- Automatic tiling via [autotiling](https://github.com/nwg-piotr/autotiling) script. Split direction depends on the currently focused window dimensions.

- Automatic tiling freed up ``Super + H`` shortcut. So i'm using HJKL to navigate inside WM.

- UI scale options depends on current display setup and [autorandr](https://github.com/phillipberndt/autorandr) profile name.

- Mouse side buttons bound to copy and paste in graphics applications. Although I try to use the mouse less, it's useful for (web)apps with mouse-centric UI.

- CapsLock is changed to Backspace.


## Restore backup:
### Please don't do this without understanding all files and commands! 

Note: before proceed you need to create or restore ssh keys and install git 

### Download config files and install packages from AUR
```
git clone --depth=1 git@github.com:coffebar/dotfiles.git dotfiles_tmp
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

# patch config
npm config set prefix ~/.node_modules

```

### Neovim plugins and dependencies
```
npm i -g pyright bash-language-server \
  vscode-langservers-extracted \
  typescript typescript-language-server \
  @tailwindcss/language-server \
  eslint
yay -Sy --needed -ltex-ls-bin rust-analyzer phpactor lua-language-server nvim-packer-git
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

### Telegram desktop theme:
### [arcdarkgrey](https://t.me/addtheme/arcdarkgrey)

--- 


<!-- vim:filetype=markdown -->
