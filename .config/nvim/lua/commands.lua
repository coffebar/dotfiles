vim.api.nvim_create_user_command('Ffnd', "call fzf#run({'source': '~/.config/nvim/find_to_edit.sh', 'sink': 'e'})", {})

local augroup = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup,
	desc = 'Return to last edit position when opening files',
	command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif'
})
