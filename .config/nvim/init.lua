require("coffebar.commands")
require("coffebar.opt")
-- plugins
require("coffebar.lazy")
-- keymap goes after mapleader and after plugins
require("coffebar.keymap")
require("coffebar.filetype")

if vim.env.TERM == "linux" then
	-- without GUI
	require("coffebar.tty")
else
	require("coffebar.colorscheme")
end
