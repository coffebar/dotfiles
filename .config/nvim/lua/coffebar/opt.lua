local g = vim.g
local opt = vim.opt

g.mapleader = " "

opt.relativenumber = true
opt.timeoutlen = 500
opt.errorbells = false
opt.number = true
opt.shiftwidth = 2
-- show tabs as 2 spaces
opt.tabstop = 2
opt.expandtab = false
opt.softtabstop = 2
opt.ignorecase = true
opt.smartcase = true
opt.swapfile = false
opt.backup = false
opt.undodir = "/tmp/.vim-undodir"
opt.undofile = true
opt.undolevels = 200 -- default is 1000
opt.termguicolors = true
opt.background = "dark"
-- show file path in the title
opt.titlestring = " %F"
opt.title = true
-- disable displaying current mode second time after statusline
opt.showmode = false
-- don't add EOL to the end of file if missing
opt.fixendofline = false

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime = 350

opt.langremap = true
opt.langmap =
	"ФИСВУАПРШОЛДЬТЩЗЙКІЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкіегмцчня;abcdefghijklmnopqrstuvwxyz"

-- show output of asyncrun.vim (0 - hidden)
g.asyncrun_open = 5
g.asynctasks_extra_config = {
	"~/.config/nvim/asynctasks.ini",
}
-- hide quickfix window after asynctask finished
g.asyncrun_exit = 'call timer_start(4000, {-> execute("cclose")})'

g.diagnostic_signs = {
	ERROR = " ",
	WARN = " ",
	INFO = " ",
	HINT = " ",
}

-- gruvbox colorscheme options
g.gruvbox_contrast_dark = "hard"
g.gruvbox_invert_selection = "0"
