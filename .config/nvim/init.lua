require("commands")
require("opt")
require("keymap") -- keymap goes after mapleader
require("filetype")

if vim.env.TERM == "linux" then
	-- without GUI
	require("tty")
else
	require("colorscheme")
end
