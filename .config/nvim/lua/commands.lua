vim.api.nvim_create_user_command('Ffnd', "call fzf#run({'source': '~/.config/nvim/find_to_edit.sh', 'sink': 'e'})", {})

local augroup = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup,
	desc = 'Return to last edit position when opening files',
	command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif'
})

vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup,
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.svg", },
	desc = 'Open images in external viewer-editor',
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
			vim.api.nvim_command('AsyncRun -silent ' .. program .. ' %:p &')
			-- image buffer is not useful in binary representation.
			-- Will close buffer without closing a window
			vim.api.nvim_command('bp | sp | bn | bd')
		end
	end
})

vim.api.nvim_create_autocmd('BufReadPre', {
	group = augroup,
	desc = 'Disable filetype for large files (>50MB)',
	command = 'let f=expand("<afile>") | if getfsize(f) > 1024*1024*50 | set eventignore+=FileType | else | set eventignore-=FileType | endif'
})
