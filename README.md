# .dotfiles backup for Arch setup

![Screenshot](https://raw.githubusercontent.com/coffebar/dotfiles/master/screenshot.png)


Requirements listed in pkglist.txt

## Interesting features

- Some of wm's binds improved by Lua script. Lua has more flexibility than i3config syntax. I like to switch automatically to the appropriate workspace after opening programs using a keyboard shortcut.

- ``Alt + f`` open a file manager in that directory what was found in clipboard. For example, if you copied a file from some program, you can open its directory just by pressing this shortcut.

- ``Super + ` `` open ssh servers menu to connect.

- ``Super + \ `` open fuzzy finder to search for local text files in the home directory to edit in Neovim.

- Automatic tiling via [autotiling](https://github.com/nwg-piotr/autotiling) script. Split direction depends on the currently focused window dimensions.

- Neovim [opens](https://github.com/coffebar/dotfiles/blob/master/.config/nvim/lua/commands.lua) popular image formats in external viewer ([pix](https://github.com/linuxmint/pix)) instead of binary view.

- Automatic tiling freed up ``Super + H`` shortcut. So I'm using HJKL to navigate inside WM.

- UI scale options depends on current display setup and [autorandr](https://github.com/phillipberndt/autorandr) profile name.

- Mouse side buttons bound to copy and paste in graphics applications. Although I try to use the mouse less, it's useful for (web)apps with mouse-centric UI.

- CapsLock is changed to Backspace.

- Nice aliases: i to install package, 'md2pdf' to convert markdown file to pdf, v to open Neovim. 

- Not using Display Managers.

- ``Ctrl + m`` bind simplifies sequence ``Ctrl + l, Ctrl + v, Return`` to interact with file-picker dialog by selecting file from clipboard blazing fast.


## Restore backup:
### Please don't do this without understanding all files and commands! 

Note: before proceed you need to create or restore ssh keys and install git 

### Download config files and install packages from AUR
```bash
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

# enable services
sudo systemctl enable --now input-remapper
sudo systemctl enable --now docker
sudo systemctl enable --now tlp
sudo systemctl enable --now ufw

# install ohmyzsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# copy ksnip config
cp -f ~/.config/ksnip/ksnip.example.conf ~/.config/ksnip/ksnip.conf

```

### Neovim plugins and dependencies
Run this script to sync Neovim config from this repo. It can be used separately on Arch systems.
```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/coffebar/dotfiles/master/fetch-nvim-conf.sh)"
```
Optionally, add a cronjob to keep Neovim plugins updated
```bash
(crontab -l; echo "0 13 * * * nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'" ) | crontab -
```

This [neovim](https://github.com/neovim/neovim) setup supports syntax highlighting and code completion for following languages: 

Bash CSS Go HTML JavaScript Lua PHP Python Rust Typescript

### Telegram desktop theme:
### [arcdarkgrey](https://t.me/addtheme/arcdarkgrey)

### GTK options
Next options will tell GTK-based apps to prefer Dark theme and open file chooser by default in the home directory.
```bash
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd

```
