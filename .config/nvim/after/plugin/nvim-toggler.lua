local installed, plugin = pcall(require, "nvim-toggler")
if not installed then
	return
end
-- add <leader>i to invert values
plugin.setup({
	inverses = {
		["0"] = "1",
		-- defaults:
		-- ['true'] = 'false',
		-- ['yes'] = 'no',
		-- ['on'] = 'off',
		-- ['left'] = 'right',
		-- ['up'] = 'down',
		-- ['!='] = '==',
	},
})
