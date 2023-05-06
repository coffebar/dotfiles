local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })
local au = vim.api.nvim_create_autocmd

vim.api.nvim_create_user_command("SearchInHome", function()
	require("telescope.builtin").find_files({
		cwd = "~",
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"--one-file-system",
			"--ignore-file",
			".config/nvim/ignore.rg",
			"--max-depth",
			"7",
		},
	})
end, {})

au("DirChanged", {
	group = augroup,
	desc = "Source local nvim config",
	callback = function()
		local rc = ".vimrc.lua"
		if vim.fn.filereadable(rc) == 1 then
			local cwd = vim.fn.getcwd()
			local confirm = "Do you trust " .. cwd .. "/" .. rc .. "?"
			if vim.fn.confirm(confirm, "Yes\nNo") == 1 then
				vim.api.nvim_command("source " .. rc)
			end
		end
	end,
})

au("BufReadPost", {
	group = augroup,
	desc = "Return to last edit position when opening files",
	command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif',
})

au("BufReadPost", {
	group = augroup,
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.svg" },
	desc = "Open images in external viewer-editor",
	callback = function()
		local image_viewers = {
			-- first found program will be used to open image
			"pix", -- https://github.com/linuxmint/pix
			"feh",
		}
		-- search for installed program
		local program
		for _, p in ipairs(image_viewers) do
			if vim.fn.executable(p) == 1 then
				program = p
				break
			end
		end
		if program then
			vim.api.nvim_command("AsyncRun -silent " .. program .. " %:p &")
			-- image buffer is not useful in binary representation.
			-- Will close buffer without closing a window
			vim.api.nvim_command("bp | sp | bn | bd")
		end
	end,
})

-- Auto change ENV variables to enable
-- bare git repository for dotfiles after
-- loading saved session
local home = vim.fn.expand("~")
local git_dir = home .. "/dotfiles"
if vim.fn.isdirectory(git_dir) then
	local dotfiles_locations = {
		-- cwd locations in dotfiles
		home,
		vim.fn.expand(home .. "/.config/nvim"),
	}
	local in_dotfiles = function()
		local cwd = vim.loop.cwd()
		for _, p in ipairs(dotfiles_locations) do
			if p == cwd then
				return true
			end
		end
		return false
	end
	au("SessionLoadPost", {
		group = augroup,
		callback = function()
			if vim.env.GIT_DIR == nil and in_dotfiles() then
				-- export git location into ENV
				vim.env.GIT_DIR = git_dir
				vim.env.GIT_WORK_TREE = home
				return
			end
			if vim.env.GIT_DIR == git_dir and not in_dotfiles() then
				-- unset variables
				vim.env.GIT_DIR = nil
				vim.env.GIT_WORK_TREE = nil
			end
		end,
	})
end

-- Optimize for large files
au("BufReadPre", {
	group = augroup,
	desc = "Disable filetype for large files (>1MB)",
	command = 'let f=expand("<afile>") | if getfsize(f) > 1024*1024*1 | set eventignore+=FileType | else | set eventignore-=FileType | endif',
})

-- Auto formatting
au("BufWritePost", {
	group = augroup,
	pattern = { "*.scss", "*.lua", "*.html" },
	desc = "Format files on write",
	callback = function()
		vim.api.nvim_command("FormatWrite")
	end,
})

-- Highlight yanked text
au("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ on_visual = false, timeout = 150 })
	end,
})

-- Git commit spell checking
au("FileType", {
	pattern = { "gitcommit", "markdown" },
	group = augroup,
	callback = function()
		vim.opt_local.spell = true
	end,
})

au("FileType", {
	pattern = {
		"help",
		"qf",
		"fugitive",
		"git",
		"fugitiveblame",
		"floggraph",
		"checkhealth",
	},
	callback = function()
		vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", {
			buffer = true,
			silent = true,
		})
	end,
	group = vim.api.nvim_create_augroup("aux_win_close", {}),
})

au("TermOpen", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
	desc = "Disable line numbers in terminal",
	group = augroup,
})
