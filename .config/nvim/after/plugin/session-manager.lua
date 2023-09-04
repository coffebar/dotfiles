local sm_installed, session_manager = pcall(require, "session_manager")
local pr_installed, project_nvim = pcall(require, "project_nvim")

if sm_installed then
	local Autoload = require("session_manager.config").AutoloadMode

	-- SessionManager options
	local sm_opt = {
		autosave_last_session = true, -- Automatically save last session on exit and on session switch.
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
			"gitrebase",
			"qf",
		},
		autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
		max_path_length = 150, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
	}

	local function sm_disabled()
		-- setup SessionManager as disabled
		sm_opt.autoload_mode = Autoload.Disabled
		sm_opt.autosave_last_session = false
		sm_opt.autosave_ignore_not_normal = true
		sm_opt.autosave_only_in_session = true
		session_manager.setup(sm_opt)
	end

	if pr_installed then
		local function contains(table, element)
			for _, value in pairs(table) do
				if value == element then
					return true
				end
			end
			return false
		end

		local function is_no_sessions_mode()
			local argv = vim.v.argv
			return contains(argv, "--") or contains(argv, "bd! | SearchInHome")
		end

		if is_no_sessions_mode() then
			-- Without pojects mode
			sm_disabled()
		else
			-- Setup project_nvim

			-- Set SessionManager Autoload Mode
			sm_opt.autoload_mode = Autoload.LastSession

			local datapath
			-- The session path is hard-coded,
			-- and the session data is based on the absolute path
			local synced_sessions_location = "/home/abc/Sync/nvim"
			if vim.fn.isdirectory(synced_sessions_location) == 1 then
				datapath = synced_sessions_location
				sm_opt.sessions_dir = datapath .. "/sessions"
			else
				-- if hard-coded path not exists on current machine,
				-- use ~/.local/share/nvim/
				datapath = vim.fn.stdpath("data")
			end

			project_nvim.setup({
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
				datapath = datapath,
			})

			local project_root, _ = require("project_nvim.project").get_project_root()
			if project_root ~= nil then
				sm_opt.autoload_mode = Autoload.CurrentDir
			end
			session_manager.setup(sm_opt)
		end
	else
		-- SessionManager is disabled without project_nvim
		sm_disabled()
	end
end
