local installed, plugin = pcall(require, "gitsigns")
if installed then
	plugin.setup({})
end
