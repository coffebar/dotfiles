require("project_nvim").setup({
	session_autoload = true,
	silent_chdir = false,
	exclude_dirs = {
		"~/.local/*",
		"~/.cache/*",
		"~/.cargo/*",
		"~/.node_modules/*",
		"~/lua",
	},
})
