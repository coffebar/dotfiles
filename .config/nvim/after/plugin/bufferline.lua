local installed, plugin = pcall(require, "bufferline")
if not installed then
	return
end
vim.opt.termguicolors = true
---@diagnostic disable-next-line: missing-fields
plugin.setup({
	---@diagnostic disable-next-line: missing-fields
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		show_buffer_close_icons = false,
	},
})
