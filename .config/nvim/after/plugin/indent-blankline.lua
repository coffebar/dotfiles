if vim.env.TERM ~= "linux" then
	vim.opt.list = true
	vim.opt.listchars:append("space:⋅")
	vim.opt.listchars:append("eol:↴")

	local installed, plugin = pcall(require, "ident_blankline")
	if installed then
		plugin.setup({
			show_end_of_line = true,
			space_char_blankline = " ",
		})
	end
end
