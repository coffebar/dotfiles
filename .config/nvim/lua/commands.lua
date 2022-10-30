vim.api.nvim_create_user_command('Ffnd', "call fzf#run({'source': '~/.config/nvim/find_to_edit.sh', 'sink': 'e'})", {})

local augroup = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup,
	desc = 'Return to last edit position when opening files',
	command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif'
})


vim.api.nvim_create_autocmd('BufReadPre', {
	group = augroup,
	desc = 'Disable filetype for large files (>50MB)',
	command = 'let f=expand("<afile>") | if getfsize(f) > 1024*1024*50 | set eventignore+=FileType | else | set eventignore-=FileType | endif'
})
