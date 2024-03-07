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
  - :robot: Emulator: [Alacritty](https://alacritty.org/) with [_JetBrains Mono_](https://www.jetbrains.com/lp/mono/) font (use Nerd Fonts)
  - [🌌 Shell](https://github.com/coffebar/dotfiles#overview): Zsh with [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh) and `robbyrussell` theme
- [✏️ Editors](https://github.com/coffebar/dotfiles#overview):
  - [:green_heart: neovim](https://neovim.io/) :green_heart:
  - 🦍 obsidian
- [:art: Themes](https://github.com/coffebar/dotfiles#overview):

  - :desktop_computer: [Arc-Dark](https://github.com/horst3180/arc-theme) GTK theme
  - :basecamp: [bloom-classic](https://github.com/linuxdeepin/deepin-icon-theme) Icons and bloom cursor (from deepin)
  - :new_moon_with_face: Telegram theme: [ArcDarkGrey](https://t.me/addtheme/arcdarkgrey)
  - :robot: Terminal colors: mix of the OneDark, Arc-Dark and PopOS
  - :green_heart: Neovim:
  - [onedark](https://github.com/navarasu/onedark.nvim) with background color from Arc-Dark
  - [gruvbox](https://github.com/gruvbox-community/gruvbox) - only in TTY

- [:pushpin: Bars](https://github.com/coffebar/dotfiles#overview):
  - :womans_hat: [waybar](https://github.com/Alexays/Waybar) on Hyprland
  - :tophat: [polybar](https://github.com/polybar/polybar) on i3
- [:brain: Task manager](https://github.com/coffebar/dotfiles#overview):
  - [:bookmark_tabs: Taskwarrior-tui](https://github.com/kdheepak/taskwarrior-tui) dark themed and configured as floating modal

## Table of Contents

- [Overview](#overview)
- [Interesting features](#interesting-features)
- [Neovim plugins full list](#neovim-plugins-full-list)
- [Restore Neovim config and install dependencies on Arch](#restore-neovim-config)
  - [Preview Neovim setup in Docker](#preview-neovim-setup-in-docker)
  - [Replace config on your machine](#replace-config-on-your-machine)
- [Install dotfiles](#install-dotfiles)

## Interesting features

#### Neovim

- PDE with code completion from many sources (including ripgrep, LSP, path and copilot), a bunch of LSP servers, autosave sessions and files, clipboard history, code formatting, color picker, fuzzy finder, git integration, incremental selection, quick project switching, code snippets, syncing of everything across devices.

- `Super + F` quick search files inside $HOME using ripgrep with a custom ignore file.

- Neo-tree has custom mappings: `Y` Copy absolute path, `t` Open directory in Thunar, `<c-r>` Replace in folder via Spectre, `<c-f>` Search with Telescope live grep.

- dotfiles bare repository will be detected by vim-fugitive, because my config updates environment variables on DirChanged event.

- `Super + er` open Telescope to select \*.sh script inside project and run it. Useful for build, run, deploy, any automation. Output will be shown in the quickfix window and hidden after timeout.

- `Super + t` opens Neovim's builtin Terminal. `Super + sa` opens external Alacritty in the current working directory.

- `Super + b` close editor's buffer or `q` - close any other window (help, fugitive, spectre)

- Different colorscheme and options for TTY.

- Automated [setup with all dependencies](#replace-config-on-your-machine) from scratch in 10 minutes.

- Neovim opens images in the external viewer instead of binary view.

- Extra keybindings for copy-pasting: file path, current line, entire file contents.

- And a bunch of other useful plugins. See [Neovim plugins full list](#neovim-plugins-full-list).

#### Common for Window managers

- Notifications when the battery level is low or fully charged.

- `Alt + f` opens a file manager in the directory found in the clipboard. For example, if you copied a file from some program, you can open its directory by pressing this shortcut.

- Partially different config for each machine depending on hostname.

- CapsLock's behavior is changed to Backspace.

- `Super + P` pull dotfiles from this repo and shows a notification with an icon.

- ``Super + ` `` open ssh servers menu to connect.

- No Display Managers (LightDM or GDM).

#### i3

- Automatic tiling via [autotiling](https://github.com/nwg-piotr/autotiling) script. Split direction depends on the currently focused window dimensions. I'm using vim-style HJKL to navigate inside WM.

- UI scale options depend on the current display setup and [autorandr](https://github.com/phillipberndt/autorandr) profile name.

- ``Super + \ `` open fuzzy finder to search for local text files in the home directory to edit in Neovim.

- Some of wm's binds were improved by Lua script. Lua has more flexibility than i3config syntax. I like to switch automatically to the appropriate workspace after opening programs using a keyboard shortcut.

#### Terminal

- ``Alt + e`` execute suggested command from zsh-autosuggestions.

- ``Ctrl + x`` after typing `# comment question` provides OpenAI generated suggestion.

- ``Command + c`` ``Command + v`` copy & paste. `Ctrl + c` and `Ctrl + p` in neovim.

- Nice aliases: **i** to install package, **md2pdf** to convert markdown file to pdf, **v** to open Neovim, **yy** to perform system upgrade. 

- Custom pacman hook updates the list of explicitly installed packages (pkglist-intel.txt) when install or remove something.


#### Neovim project management

https://github.com/coffebar/neovim-project/assets/3100053/e88ae41a-5606-46c4-a287-4c476ed97ccc

📦 [neovim-project](https://github.com/coffebar/neovim-project) plugin


## Neovim plugins full list

<!-- plugins list start -->
- [0oAstro/dim.lua](https://github.com/0oAstro/dim.lua)  Dim unused words in neovim
- [AckslD/nvim-neoclip.lua](https://github.com/AckslD/nvim-neoclip.lua)  Clipboard manager neovim plugin with telescope integration
- [HallerPatrick/py_lsp.nvim](https://github.com/HallerPatrick/py_lsp.nvim)  Lsp Plugin for working with Python virtual environments
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)  Snippet Engine for Neovim written in Lua.
- [Mofiqul/dracula.nvim](https://github.com/Mofiqul/dracula.nvim)  Dracula colorscheme for neovim written in Lua
- [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)  UI Component Library for Neovim.
- [NeogitOrg/neogit](https://github.com/NeogitOrg/neogit)  An interactive and powerful Git interface for Neovim, inspired by Magit
- [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)  Maintained fork of the fastest Neovim colorizer
- [Pocco81/AutoSave.nvim](https://github.com/Pocco81/AutoSave.nvim)  🧶 Automatically save your changes in NeoVim
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)  illuminate.vim - (Neo)Vim plugin for automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
- [Shatur/neovim-session-manager](https://github.com/Shatur/neovim-session-manager)  A simple wrapper around :mksession.
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon) ThePrimeagen/harpoon
- [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)  A neovim lua plugin to help easily manage multiple terminal windows
- [bloznelis/before.nvim](https://github.com/bloznelis/before.nvim)  Plugin for Neovim which tracks edit locations
- [ckipp01/stylua-nvim](https://github.com/ckipp01/stylua-nvim)  Let&#39;s just use a formatter and never discuss formatting again.
- [coffebar/crowtranslate.nvim](https://github.com/coffebar/crowtranslate.nvim)  Translate the visually selected text in Neovim.
- [coffebar/neovim-project](https://github.com/coffebar/neovim-project)  Neovim project manager maintains your recent project history and uses Telescope to select from autosaved sessions.
- [coffebar/transfer.nvim](https://github.com/coffebar/transfer.nvim)  Syncing files with remote server using rsync and OpenSSH
- [cohama/lexima.vim](https://github.com/cohama/lexima.vim)  Auto close parentheses and repeat by dot dot dot...
- [elihunter173/dirbuf.nvim](https://github.com/elihunter173/dirbuf.nvim)  A file manager for Neovim which lets you edit your filesystem like you edit text
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)  🚦 A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)  💥   Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
- [github/copilot.vim](https://github.com/github/copilot.vim)  Neovim plugin for GitHub Copilot
- [glepnir/lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim)  improve neovim lsp experience
- [google/vim-searchindex](https://github.com/google/vim-searchindex)  vim-searchindex: display number of search matches &amp; index of a current match
- [gruvbox-community/gruvbox](https://github.com/gruvbox-community/gruvbox)  Retro groove color scheme for Vim - community maintained edition
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)  nvim-cmp source for buffer words
- [hrsh7th/cmp-calc](https://github.com/hrsh7th/cmp-calc)  nvim-cmp source for math calculation
- [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)  nvim-cmp source for vim&#39;s cmdline
- [hrsh7th/cmp-emoji](https://github.com/hrsh7th/cmp-emoji)  nvim-cmp source for emoji
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)  nvim-cmp source for neovim builtin LSP client
- [hrsh7th/cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)  cmp-nvim-lsp-signature-help
- [hrsh7th/cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)  nvim-cmp source for nvim lua
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)  nvim-cmp source for path
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)  A completion plugin for neovim coded in Lua.
- [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)  markdown preview plugin for (neo)vim
- [ibutra/checkbox.nvim](https://github.com/ibutra/checkbox.nvim)  Simple checkbox handling for neovim
- [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim)  💫  Extensible UI for Neovim notifications and LSP progress messages.
- [johmsalas/text-case.nvim](https://github.com/johmsalas/text-case.nvim)  An all in one plugin for converting text case in Neovim
- [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak)  The missing motion for Vim :athletic_shoe:
- [klen/nvim-test](https://github.com/klen/nvim-test)  A Neovim wrapper for running tests
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)  Add/change/delete surrounding delimiter pairs with ease. Written with in Lua.
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)  Git integration for buffers
- [lukas-reineke/cmp-rg](https://github.com/lukas-reineke/cmp-rg)  ripgrep source for nvim-cmp
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)  Indent guides  for Neovim
- [m-demare/hlargs.nvim](https://github.com/m-demare/hlargs.nvim)  Highlight arguments&#39; definitions and usages, using Treesitter
- [mawkler/modicator.nvim](https://github.com/mawkler/modicator.nvim)  Cursor line number mode indicator plugin for Neovim
- [mboughaba/i3config.vim](https://github.com/mboughaba/i3config.vim)  Vim syntax highlighting for i3 config :point_left:
- [mhartington/formatter.nvim](https://github.com/mhartington/formatter.nvim) mhartington/formatter.nvim
- [moll/vim-bbye](https://github.com/moll/vim-bbye)  Delete buffers and close files in Vim without closing your windows or messing up your layout. Like Bclose.vim, but rewritten and well maintained.
- [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim)  One dark and light colorscheme for neovim &gt;= 0.5.0 written in lua based on Atom&#39;s One Dark and Light theme. Additionally, it comes with 5 color variant styles
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)  Quickstart configs for Nvim LSP
- [nguyenvukhang/nvim-toggler](https://github.com/nguyenvukhang/nvim-toggler)  invert text in vim, purely with lua.
- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)  :brain: // Smart and powerful comment plugin for neovim. Supports treesitter, dot repeat, left-right/up-down motions, hooks, and more
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)  plenary: full; complete; entire; absolute; unqualified. All the lua functions I don&#39;t want to write twice.
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)  A blazing fast and easy to configure neovim statusline plugin written in pure lua.
- [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)  Neovim plugin to manage the file system and other tree like structures.
- [nvim-pack/nvim-spectre](https://github.com/nvim-pack/nvim-spectre)  Find the enemy and replace them with dark power.
- [nvim-telescope/telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)  Live grep with args
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)  Find, Filter, Preview, Pick. All lua, all the time.
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)  lua `fork` of vim-web-devicons for neovim
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)  Nvim Treesitter configurations and abstraction layer
- [petertriho/cmp-git](https://github.com/petertriho/cmp-git)  Git source for nvim-cmp
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)  Set of preconfigured snippets for different languages.
- [rafcamlet/nvim-luapad](https://github.com/rafcamlet/nvim-luapad)  Interactive real time neovim scratchpad for embedded lua engine - type and watch!
- [rbong/vim-flog](https://github.com/rbong/vim-flog)  A fast, beautiful, and powerful git branch viewer for vim.
- [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)  A fancy, configurable, notification manager for NeoVim
- [romainl/vim-cool](https://github.com/romainl/vim-cool)  A very simple plugin that makes hlsearch more useful.
- [romgrk/barbar.nvim](https://github.com/romgrk/barbar.nvim)  The neovim tabline plugin.
- [romgrk/nvim-treesitter-context](https://github.com/romgrk/nvim-treesitter-context)  Show code context
- [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)  luasnip completion source for nvim-cmp
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim)  Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
- [skywind3000/asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)  :rocket: Run Async Shell Commands in Vim 8.0 / NeoVim and Output to the Quickfix Window !!
- [skywind3000/asynctasks.vim](https://github.com/skywind3000/asynctasks.vim)  :rocket: Modern Task System for Project Building, Testing and Deploying !!
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)  fugitive.vim: A Git wrapper so awesome, it should be illegal
- [tzachar/highlight-undo.nvim](https://github.com/tzachar/highlight-undo.nvim)  Highlight changed text after Undo / Redo operations
- [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)  Use treesitter to auto close and auto rename html tag
<!-- plugins list end -->



## Restore Neovim config

### Preview Neovim setup in Docker

Full Neovim setup can be tested inside docker container.

```bash
git clone https://github.com/coffebar/docker-test-fetch-nvim-conf.git
cd docker-test-fetch-nvim-conf && sh ./build.sh
```

See [docker-test-fetch-nvim-conf](https://github.com/coffebar/docker-test-fetch-nvim-conf) repo for more details.

### Replace config on your machine

`fetch-nvim-conf.sh` script helps me to get my full Neovim config installed on any Arch Linux machine with all dependencies.  
It's not just clone repo. This script requires Arch Linux with **pacman**, **sudo** and **git** installed. It will install required packages, **pnpm** package manager and node modules for LSP & formatting.

It will overwrite the entire `~/.config/nvim` folder!

[Review source](https://github.com/coffebar/dotfiles/blob/main/fetch-nvim-conf.sh)

```bash
# export PATH="$PATH:$HOME/.local/share/pnpm:$HOME/.node_modules/bin"
sh -c "$(wget -O- https://raw.githubusercontent.com/coffebar/dotfiles/main/fetch-nvim-conf.sh)"
```

<details><summary>
<h2>Install dotfiles</h2>
</summary>

**Please don't do this if you're not me**

**This instruction will work as is for coffebar only!**

1. Before proceeding you need to restore SSH and GPG keys.

2. SSH config must point to the GitHub's private key.

[Review source](https://github.com/coffebar/dotfiles/blob/main/dotfiles-restore.sh)

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/coffebar/dotfiles/main/dotfiles-restore.sh)"
```

</details>
