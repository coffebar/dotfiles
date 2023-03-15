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
	ignore_lsp = {
		"lua_ls",
	},
	patterns = {
		"!>home",
		"!=tmp",
		".git",
		".idea",
		".svn",
		"PKGBUILD",
		"composer.json",
		"package.json",
		"Makefile",
		"README.md",
		"Cargo.toml",
		">Work",
		">pets",
	},
})
