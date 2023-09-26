-- function to shorten mappings
local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", outer_opts, opts or {})
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

local nnoremap = bind("n")
-- local nmap = bind("n", { noremap = false })
local vnoremap = bind("v")
local xnoremap = bind("x")
local inoremap = bind("i")
local tnoremap = bind("t")
-- press jk to exit from insert mode
inoremap("jk", "<Esc>")
inoremap("kj", "<Esc>")
-- copy to system clipboard by Ctrl+c in the Visual mode
vnoremap("<C-c>", '"+y')
-- paste in normal mode from system clipboard
vnoremap("<C-p>", '"+p')
nnoremap("<C-p>", '"+p')
inoremap("<C-p>", '<esc>"+p')

-- center cursor on scroll
nnoremap("<C-d>", "<C-d>zz0")
nnoremap("<C-u>", "<C-u>zz0")

-- copy current buffer's absolute path to clipboard
nnoremap("<leader>cl", '<cmd>let @+=expand("%:p")<cr>')
-- plugin with Yank history
nnoremap("<leader>cr", "<cmd>Telescope neoclip<cr>")
-- copy current line to system clipboard
nnoremap("<leader>cc", '"+yy')
-- source current buffer
nnoremap("<leader>cs", "<cmd>so %<cr>")

-- quit
nnoremap("<leader>a", "<cmd>qa!<cr>")

nnoremap("0", "^")
-- add blank line
nnoremap("<leader>o", "o<ESC>")
nnoremap("<leader>O", "O<ESC>")
-- don't yank when press x
nnoremap("x", '"_x')

-- append ; to the end of line
inoremap("<leader>;", "<Esc>A;<Esc>")
nnoremap("<leader>;", "<Esc>A;<Esc>")
nnoremap("Ф", "A")
nnoremap("Ш", "I")

-- Git
nnoremap("<leader>gs", "<cmd>Gitsigns stage_hunk<cr>")
nnoremap("<leader>gS", "<cmd>Gitsigns stage_buffer<cr>")
nnoremap("<leader>gr", "<cmd>Gitsigns reset_hunk<cr>")
nnoremap("<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>")
nnoremap("<leader>gR", "<cmd>Gitsigns reset_buffer<cr>")
nnoremap("<leader>gp", "<cmd>AsyncRun git push<cr>")
-- view history for selection
vnoremap("<leader>gh", "<cmd>'<,'>DiffviewFileHistory<cr>")
nnoremap("gp", "<cmd>AsyncRun git pull<cr>")
nnoremap("<leader>gl", "<cmd>Flog -date=short<cr>")
-- Fugitive
nnoremap("<leader>gg", "<cmd>vert Git<cr>")
nnoremap("<leader>gc", "<cmd>Git commit -v<cr>")

nnoremap("<leader>F", "<cmd>SearchInHome<cr>") -- open file and edit
-- NeoTree
nnoremap("<leader>n", "<cmd>Neotree focus toggle<cr>")
nnoremap("<leader>N", "<cmd>Neotree reveal<cr>")
nnoremap("=", "<cmd>Format<cr>")
-- Ctrl+4 to close window and keep buffer
nnoremap("<C-\\>", "<cmd>q<cr>")

-- nnoremap("<leader>l", "<cmd>bnext<cr>")
-- nnoremap("<leader>h", "<cmd>bprevious<cr>")

-- install and update plugins
nnoremap("<leader>sp", "<cmd>Lazy sync<cr>")
-- search and replace
local has_spectre, spectre = pcall(require, "spectre")
if has_spectre then
  nnoremap("<leader>rr", spectre.open)
  nnoremap("<leader>rw", function()
    -- search current word
    spectre.open_visual({ select_word = true })
  end)
  vnoremap("<leader>rr", spectre.open_visual)
  nnoremap("<leader>rf", spectre.open_file_search)
end
-- AsyncTask
nnoremap("<leader>eb", "<cmd>AsyncTask project-build<cr>")
nnoremap("<leader>er", "<cmd>AsyncTask project-run<cr>")
nnoremap("<leader>ee", "<cmd>call asyncrun#quickfix_toggle(8)<cr>")
-- Close the current buffer
nnoremap("<leader>b", "<cmd>Bdelete<cr>")
-- Comment.nvim
nnoremap("gcc", function()
  return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
end, { expr = true })
vnoremap("gc", "<Plug>(comment_toggle_linewise_visual)")
-- open terminal in split below and start Insert mode
nnoremap("<leader>t", "<cmd>belowright split | resize 10 | terminal<cr>i")
-- history for current file
nnoremap("<leader>gh", "<cmd>DiffviewFileHistory %<cr>")
nnoremap("<leader>w", "<cmd>w!<cr>")

-- terminal mode related
-- close terminal window
tnoremap("<C-d>", "<C-\\><C-n><cmd>q!<cr>")
-- exit terminal insert mode
tnoremap("<Esc>", "<C-\\><C-n>")
-- exit terminal's insert mode and go to upper window
tnoremap("jk", "<C-\\><C-n><C-w>k")
-- Ctrl+4 to close terminal window
tnoremap("<C-\\>", "<C-\\><C-n><cmd>bd!<cr>")

-- keep yank register untouched when pasting text over selection
xnoremap("p", '"_dP')
