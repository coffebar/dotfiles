vim.api.nvim_create_user_command("SearchInHome", function()
	require("telescope.builtin").find_files({
		cwd = "~",
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"-g",
			"!.config/google-chrome**",
			"-g",
			"!.config/microsoft**",
			"-g",
			"!.cache/*",
			"-g",
			"!Pictures/*",
			"-g",
			"!Videos/*",
			"-g",
			"!Sync/*",
			"-g",
			"!.java/*",
			"-g",
			"!.mozilla/*",
			"-g",
			"!.rustup/*",
			"-g",
			"!.encryptfs/*",
			"-g",
			"!.local/*",
			"-g",
			"!.npm/*",
			"-g",
			"!.cargo/*",
			"-g",
			"!dotfiles/*",
			"-g",
			"!pycharm**",
			"-g",
			"!Pycharm**",
			"-g",
			"!Documents/DOC**",
			"-g",
			"!Documents/wor**",
			"-g",
			"!Documents/zm**",
			"-g",
			"!PhpStorm**",
			"-g",
			"!go/pkg/*",
			"-g",
			"!.node_modules/*",
		},
	})
end, {})

local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

vim.api.nvim_create_autocmd("DirChanged", {
	group = augroup,
	desc = "Source local nvim config",
	callback = function()
		local rc = "localrc.lua"
		if vim.fn.filereadable(rc) == 1 then
			local cwd = vim.fn.getcwd()
			local confirm = "Do you trust " .. cwd .. "/" .. rc .. "?"
			if vim.fn.confirm(confirm, "Yes\nNo") == 1 then
				vim.api.nvim_command("source localrc.lua")
			end
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Return to last edit position when opening files",
	command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif',
})

vim.api.nvim_create_autocmd("BufReadPost", {
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

vim.api.nvim_create_autocmd("BufReadPre", {
	group = augroup,
	desc = "Disable filetype for large files (>50MB)",
	command = 'let f=expand("<afile>") | if getfsize(f) > 1024*1024*50 | set eventignore+=FileType | else | set eventignore-=FileType | endif',
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup,
	pattern = { "*.scss", "*.lua", "*.html" },
	desc = "Format files on write",
	callback = function()
		vim.api.nvim_command("FormatWrite")
	end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ on_visual = false, timeout = 150 })
	end,
})

-- Git commit spell checking
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	group = augroup,
	callback = function()
		vim.opt_local.spell = true
	end,
})
