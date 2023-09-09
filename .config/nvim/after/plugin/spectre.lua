local installed, plugin = pcall(require, "spectre")
if not installed then
	return
end
plugin.setup({
	highlight = {
		ui = "String",
		search = "DiffChange",
		replace = "DiffDelete",
	},
})
