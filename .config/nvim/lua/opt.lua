local g = vim.g
local opt = vim.opt
local cmd = vim.cmd

cmd("colorscheme gruvbox")

g.mapleader = " "

g.gruvbox_contrast_dark = 'hard'
g.gruvbox_invert_selection = '0'
opt.relativenumber = true
opt.timeoutlen = 500
opt.errorbells = false
opt.number = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.ignorecase = true
opt.smartcase = true
opt.swapfile = false
opt.backup = false
opt.undodir = "/tmp/.vim-undodir"
opt.undofile = true
opt.termguicolors = true
opt.background = "dark"

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime = 350


opt.langremap = true
opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкіегмцчня;abcdefghijklmnopqrstuvwxyz'
