-- add <leader>i to invert values
require("nvim-toggler").setup({
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
