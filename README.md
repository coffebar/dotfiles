![Screenshot](/screenshot.png)

<div align="center">

![](https://img.shields.io/github/last-commit/coffebar/dotfiles?style=flat-square&logo=)
![](https://img.shields.io/github/stars/coffebar/dotfiles?style=flat-square&logo=)
[![](https://img.shields.io/github/repo-size/coffebar/dotfiles?style=flat-square&logo=)](https://github.com/iamverysimp1e/dots)

</div>

# dotfiles backup

## Overview


- [🌿 Window Managers / Compositors](https://github.com/coffebar/dotfiles#overview):
  - [🍚 Hyprland](https://github.com/hyprwm/Hyprland)
  - [🍙 i3](https://i3wm.org/) as fallback
- [👽 Terminal](https://github.com/coffebar/dotfiles#overview):
  - :robot: Emulator: [Alacritty](https://alacritty.org/) with [*JetBrains Mono*](https://www.jetbrains.com/lp/mono/) font
  - [🌌 Shell](https://github.com/coffebar/dotfiles#overview): Zsh with [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh) and `robbyrussell` theme
- [✏️ Editors](https://github.com/coffebar/dotfiles#overview):
  - [:green_heart: neovim](https://neovim.io/) :green_heart:
  - 🦍 obsidian
- [:art: Themes](https://github.com/coffebar/dotfiles#overview):
  - :desktop_computer: [Arc-Dark](https://github.com/horst3180/arc-theme) GTK theme
  - :basecamp: [bloom-classic](https://github.com/linuxdeepin/deepin-icon-theme) Icons and bloom cursor (from deepin)
  - :new_moon_with_face: Telegram theme: [ArcDarkGrey](https://t.me/addtheme/arcdarkgrey)
  - :green_heart: Neovim: 
	 - [onedark](https://github.com/navarasu/onedark.nvim) with background color from Arc-Dark 
	 - [gruvbox](https://github.com/gruvbox-community/gruvbox) - only in TTY

- [:pushpin: Bars](https://github.com/coffebar/dotfiles#overview):
  - :womans_hat: [waybar](https://github.com/Alexays/Waybar) on Hyprland
  - :tophat: [polybar](https://github.com/polybar/polybar) on i3
- [:brain: Task manager](https://github.com/coffebar/dotfiles#overview):
  - [:bookmark_tabs: Taskwarrior-tui](https://github.com/kdheepak/taskwarrior-tui) dark themed and configured as floating modal


<details><summary><h2>Interesting features</h2></summary>

#### Neovim project management

https://user-images.githubusercontent.com/3100053/225754164-b4141431-29fd-4587-9c2f-f9fc531a6986.mp4

plugin [project.nvim](https://github.com/coffebar/project.nvim)

#### Common for Window managers

- ``Alt + f`` opens a file manager in the directory found in the clipboard. For example, if you copied a file from some program, you can open its directory by pressing this shortcut.

- Mouse side buttons bound to copy and paste in graphics applications. Although I try to use the mouse less, it's useful for (web)apps with mouse-centric UI.

- CapsLock's behavior is changed to Backspace.

- I'm not using Display Managers (no LightDM or GDM).

- ``Ctrl + m`` bind simplifies sequence ``Ctrl + l, Ctrl + v, Return`` to interact with file-picker dialog by selecting file from clipboard blazingly fast.

- ``Super + P`` pull dotfiles from this repo and shows a notification with an icon.

- Notifications when the battery level is low or fully charged.

- ``Alt + Space`` close a focused window.

#### i3

- UI scale options depend on the current display setup and [autorandr](https://github.com/phillipberndt/autorandr) profile name.

- ``Super + \ `` open fuzzy finder to search for local text files in the home directory to edit in Neovim.

- Automatic tiling via [autotiling](https://github.com/nwg-piotr/autotiling) script. Split direction depends on the currently focused window dimensions.

- Some of wm's binds were improved by Lua script. Lua has more flexibility than i3config syntax. I like to switch automatically to the appropriate workspace after opening programs using a keyboard shortcut.

- ``Super + ` `` open ssh servers menu to connect.

- Automatic tiling freed up ``Super + H`` shortcut. So I'm using HJKL to navigate inside WM.

#### Terminal

- ``Alt + e`` execute suggested command from zsh-autosuggestions

- ``Command + c`` ``Command + v`` copy & paste. `Ctrl + c` and `Ctrl + p` in neovim.

- Neovim [opens](https://github.com/coffebar/dotfiles/blob/master/.config/nvim/lua/commands.lua) popular image formats in the external viewer ([pix](https://github.com/linuxmint/pix)) instead of binary view. Neovim also has a bunch of customizations and keyboard shortcuts.

- Nice aliases: **i** to install package, **md2pdf** to convert markdown file to pdf, **v** to open Neovim, **yy** to perform system upgrade. 


</details>

<details><summary><h2>Neovim plugins full list</h2></summary>

<!-- plugins list start -->
- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [skywind3000/asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)
- [skywind3000/asynctasks.vim](https://github.com/skywind3000/asynctasks.vim)
- [Pocco81/auto-save.nvim](https://github.com/Pocco81/auto-save.nvim)
- [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [coffebar/ccc.nvim](https://github.com/coffebar/ccc.nvim)
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [hrsh7th/cmp-calc](https://github.com/hrsh7th/cmp-calc)
- [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [hrsh7th/cmp-emoji](https://github.com/hrsh7th/cmp-emoji)
- [petertriho/cmp-git](https://github.com/petertriho/cmp-git)
- [David-Kunz/cmp-npm](https://github.com/David-Kunz/cmp-npm)
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [hrsh7th/cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
- [hrsh7th/cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)
- [lukas-reineke/cmp-rg](https://github.com/lukas-reineke/cmp-rg)
- [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [narutoxy/dim.lua](https://github.com/narutoxy/dim.lua)
- [Mofiqul/dracula.nvim](https://github.com/Mofiqul/dracula.nvim)
- [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim)
- [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [mhartington/formatter.nvim](https://github.com/mhartington/formatter.nvim)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [gruvbox-community/gruvbox](https://github.com/gruvbox-community/gruvbox)
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- [mboughaba/i3config.vim](https://github.com/mboughaba/i3config.vim)
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- [cohama/lexima.vim](https://github.com/cohama/lexima.vim)
- [glepnir/lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [Shatur/neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
- [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [AckslD/nvim-neoclip.lua](https://github.com/AckslD/nvim-neoclip.lua)
- [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)
- [klen/nvim-test](https://github.com/klen/nvim-test)
- [nguyenvukhang/nvim-toggler](https://github.com/nguyenvukhang/nvim-toggler)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [romgrk/nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context)
- [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)
- [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
- [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)
- [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [coffebar/project.nvim](https://github.com/coffebar/project.nvim)
- [ckipp01/stylua-nvim](https://github.com/ckipp01/stylua-nvim)
- [nvim-telescope/telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [johmsalas/text-case.nvim](https://github.com/johmsalas/text-case.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [romainl/vim-cool](https://github.com/romainl/vim-cool)
- [rbong/vim-flog](https://github.com/rbong/vim-flog)
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [google/vim-searchindex](https://github.com/google/vim-searchindex)
- [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
<!-- plugins list end -->

</details>


<details><summary>
<h2>Restore backup</h2>
</summary>


### Please don't do this without understanding all files and commands! 

#### Before proceeding you need to create or restore ssh keys and install git

### Download config files and install packages from AUR
```bash
git clone --bare git@github.com:coffebar/dotfiles.git dotfiles
git --git-dir=$HOME/dotfiles --work-tree=$HOME config --local core.worktree $HOME

# install yay
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
yay -Y --gendb

# install packages
mkdir -p /tmp/yay; yay -S --builddir /tmp/yay --needed --nodiffmenu --noeditmenu - < pkglist-intel.txt

# add firewall rule
sudo ufw default deny incoming
sudo ufw allow syncthing
sudo ufw enable
# enable services
sudo systemctl enable --now input-remapper docker tlp ufw bluetooth

# install ohmyzsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# copy ksnip config
cp -f ~/.config/ksnip/ksnip.example.conf ~/.config/ksnip/ksnip.conf

```

### GTK options

The next options will tell GTK-based apps to prefer a Dark theme and open file chooser by default in the home directory.

```bash
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd
# cursor and icon themes
gsettings set org.gnome.desktop.interface cursor-theme 'bloom'
gsettings set org.gnome.desktop.interface icon-theme 'bloom-classic'

```

### Neovim plugins and dependencies
Run this script to sync Neovim config from this repo. It can be used separately on Arch systems.
```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/coffebar/dotfiles/master/fetch-nvim-conf.sh)"
```

</details>



