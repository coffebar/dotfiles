local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force",
			outer_opts,
			opts or {}
		)
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

local nmap = bind("n", { noremap = false })
local nnoremap = bind("n")
local vnoremap = bind("v")
-- local xnoremap = bind("x")
local inoremap = bind("i")

-- Fast saving
nnoremap('<leader>w', ':w!<cr>')
nnoremap('<leader>ц', ':w!<cr>')
-- press jk to exit from insert mode
inoremap('jk', '<Esc>')
inoremap('kj', '<Esc>')
-- copy to system clipboard by Ctrl+c in the Visual mode
vnoremap('<C-c>', '"+y')
-- paste in normal mode from system clipboard
vnoremap('<C-p>', '"+p')
nnoremap('<C-p>', '"+p')
inoremap('<C-p>', '<esc>"+p')
-- copy current line to system clipboard
nnoremap('<leader>c', '"+yy')


-- Close all tabs
nnoremap('<leader>a', ':qa!<cr>')
nnoremap('<leader>ф', ':qa!<cr>')

nmap('Ф', 'A')
nmap('Ш', 'I')

--nnoremap('=', '<nop>')
--vnoremap('=', '<nop>')

-- Close the current buffer
nmap('<leader>bd', ':bd!<cr>')
-- Close all the buffers
nmap('<leader>ba', ':bufdo bd<cr>')

nnoremap('<leader>l', ':bnext<cr>')
nnoremap('<leader>h', ':bprevious<cr>')
-- fzf open file and edit
nnoremap('<leader>f', ':Ffnd<cr>')

nnoremap('<leader>t', ':TroubleToggle<cr>')

nnoremap('0', '^')
nnoremap('<leader>o', 'o<ESC>')
nnoremap('<leader>O', 'O<ESC>')

nnoremap("Q", "<nop>")

-- copy current line to system clipboard
nnoremap('<leader>c', '"+yy')

-- append ; to the end of line
inoremap('<leader>;', '<Esc>A;<Esc>')
nnoremap('<leader>;', '<Esc>A;<Esc>')
-- Gitsigns
nnoremap('<leader>gs', ':Gitsigns stage_hunk<cr>')
nnoremap('<leader>gS', ':Gitsigns stage_buffer<cr>')
nnoremap('<leader>gr', ':Gitsigns reset_hunk<cr>')
nnoremap('<leader>gu', ':Gitsigns undo_stage_hunk<cr>')
nnoremap('<leader>gR', ':Gitsigns reset_buffer<cr>')
