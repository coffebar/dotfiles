require("coffebar.commands")
require("coffebar.opt")
require("coffebar.keymap") -- keymap goes after mapleader
require("coffebar.filetype")

if vim.env.TERM == "linux" then
	-- without GUI
	require("coffebar.tty")
else
	require("coffebar.colorscheme")
end
