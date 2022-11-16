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

	local Path = require("plenary.path")
	local session_path = Path:new(vim.fn.stdpath("data"), "sessions")
	local Autoload = require("session_manager.config").AutoloadMode
	local mode = Autoload.LastSession -- Possible values: Disabled, CurrentDir, LastSession
	if contains(vim.v.argv, "SearchInHome") then
		mode = Autoload.Disabled
	end

	session_manager.setup({
		sessions_dir = session_path, -- The directory where the session files will be saved.
		path_replacer = "__", -- The character to which the path separator will be replaced for session files.
		colon_replacer = "++", -- The character to which the colon symbol will be replaced for session files.
		autoload_mode = mode, -- Define what to do when Neovim is started without arguments.
		autosave_last_session = true, -- Automatically save last session on exit and on session switch.
		autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
		autosave_ignore_dirs = {
			session_path,
			vim.fn.expand("~"),
			vim.fn.expand("~/.local/"),
			vim.fn.expand("~/.cache/"),
			vim.fn.expand("~/.cargo/"),
			"/tmp/",
		},
		autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
			"gitcommit",
			"qf",
		},
		autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
		max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
	})
end
