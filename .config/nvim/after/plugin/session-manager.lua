local installed, session_manager = pcall(require, "session_manager")

if installed then
	local function contains(table, element)
		for _, value in pairs(table) do
			if value == element then
				return true
			end
		end
		return false
	end

	local session_enabled = true
	local Autoload = require("session_manager.config").AutoloadMode
	local mode = Autoload.LastSession -- Possible values: Disabled, CurrentDir, LastSession
	if contains(vim.v.argv, "--") or contains(vim.v.argv, "SearchInHome") then
		mode = Autoload.Disabled
		session_enabled = false
	end

	require("project_nvim").setup({
		session_autoload = session_enabled,
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

	if session_enabled then
		local project_root, _ = require("project_nvim.project").get_project_root()
		if project_root ~= nil then
			mode = Autoload.CurrentDir
		end
	end

	session_manager.setup({
		path_replacer = "__", -- The character to which the path separator will be replaced for session files.
		colon_replacer = "++", -- The character to which the colon symbol will be replaced for session files.
		autoload_mode = mode, -- Define what to do when Neovim is started without arguments.
		autosave_last_session = session_enabled, -- Automatically save last session on exit and on session switch.
		-- I'l keep it false for smooth session switching
		autosave_ignore_not_normal = false, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
		autosave_ignore_dirs = {
			vim.fn.expand("~"),
			vim.fn.expand("~/dev/.task/"),
			"/tmp/",
		},
		autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
			"ccc-ui",
			"gitcommit",
			"qf",
		},
		autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
		max_path_length = 150, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
	})
end
