local onedark_installed, onedark = pcall(require, "onedark")
if not onedark_installed then
	print("onedark not installed")
	return
end

onedark.setup({
	style = "warm",
	transparent = false, -- Show/hide background
	term_colors = false, -- Change terminal color as per the selected theme style

	-- toggle theme style ---
	-- toggle_style_key = "<leader>co", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	-- toggle_style_list = { "darker", "deep", "warmer" }, -- List of styles to toggle between
	lualine = {
		transparent = false, -- lualine center bar transparency
	},
	colors = {
		grey = "#8b8b8b",
		fg = "#bbbbbb",
		bg0 = "#2b2e37",
	},
	code_style = {
		comments = "none",
		keywords = "none",
		functions = "none",
		strings = "none",
		variables = "none",
	},
})
onedark.load()
