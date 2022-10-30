vim.opt.termguicolors = true
require("bufferline").setup {
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		show_buffer_close_icons = false,
	}
}
