local g = vim.g
local opt = vim.opt

if vim.env.TERM == "linux" then
	opt.termguicolors = false
	opt.background = "dark"
	opt.title = false
	vim.cmd("colorscheme gruvbox")
	g.indent_blankline_enabled = false
end
