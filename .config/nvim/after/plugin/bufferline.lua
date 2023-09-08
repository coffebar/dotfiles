vim.opt.termguicolors = true
---@diagnostic disable-next-line: missing-fields
require("bufferline").setup({
	---@diagnostic disable-next-line: missing-fields
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		show_buffer_close_icons = false,
	},
})
