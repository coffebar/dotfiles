local has_wk, wk = pcall(require, "which-key")
local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

local nmap = bind("n", { noremap = false })
local nnoremap = bind("n")
local vnoremap = bind("v")
-- local xnoremap = bind("x")
local inoremap = bind("i")
local tnoremap = bind("t")

-- Fast saving
nnoremap("<leader>w", ":w!<cr>")
nnoremap("<leader>ц", ":w!<cr>")
-- press jk to exit from insert mode
inoremap("jk", "<Esc>")
inoremap("kj", "<Esc>")
-- copy to system clipboard by Ctrl+c in the Visual mode
vnoremap("<C-c>", '"+y')
-- paste in normal mode from system clipboard
vnoremap("<C-p>", '"+p')
nnoremap("<C-p>", '"+p')
inoremap("<C-p>", '<esc>"+p')

-- Close all tabs
nnoremap("<leader>a", ":qa!<cr>")
nnoremap("<leader>ф", ":qa!<cr>")

nmap("Ф", "A")
nmap("Ш", "I")

-- open terminal in split below and start Insert mode
nnoremap("<leader>t", ":belowright split | resize 10 | terminal<cr>i")

-- terminal mode related
-- close terminal window
tnoremap("<C-d>", "<C-\\><C-n>:q!<cr>")
-- exit terminal insert mode
tnoremap("<Esc>", "<C-\\><C-n>")
-- exit terminal's insert mode and go to upper window
tnoremap("jk", "<C-\\><C-n><C-w>k")
-- Ctrl+4 to close terminal window
tnoremap("<C-\\>", "<C-\\><C-n>:bd!<cr>")

-- Ctrl+4 to close window and keep buffer
nmap("<C-\\>", ":q<cr>")
nnoremap("<leader>l", ":bnext<cr>")
nnoremap("<leader>h", ":bprevious<cr>")

nnoremap("0", "^")
-- add blank line
nnoremap("<leader>o", "o<ESC>")
nnoremap("<leader>O", "O<ESC>")
-- don't yank when press x
nnoremap("x", '"_x')

nnoremap("Q", "<nop>")

-- append ; to the end of line
inoremap("<leader>;", "<Esc>A;<Esc>")
nnoremap("<leader>;", "<Esc>A;<Esc>")
-- Diagnostic details
nnoremap("<leader>T", ":TroubleToggle<cr>")
-- Git
nnoremap("<leader>gs", ":Gitsigns stage_hunk<cr>")
nnoremap("<leader>gS", ":Gitsigns stage_buffer<cr>")
nnoremap("<leader>gr", ":Gitsigns reset_hunk<cr>")
nnoremap("<leader>gu", ":Gitsigns undo_stage_hunk<cr>")
nnoremap("<leader>gR", ":Gitsigns reset_buffer<cr>")
nnoremap("<leader>gp", ":AsyncRun git push<cr>")
-- Fugitive
nnoremap("<leader>gg", ":Git<cr>")
nnoremap("<leader>gc", ":Git commit -v<cr>")
-- Telescope
nnoremap("<leader>ff", ":Telescope find_files<cr>")
nnoremap("<leader>fb", ":Telescope file_browser<cr>")
nnoremap("<leader>fg", ":Telescope live_grep<cr>")
nnoremap("<leader>fj", ":Telescope jumplist<cr>")
nnoremap("<leader>fs", ":Telescope git_status<cr>")
nnoremap("<leader>fh", ":Telescope command_history<cr>")
nnoremap("<leader>fr", ":Telescope registers<cr>")
nnoremap("<leader>p", ":Telescope projects<cr>")
nnoremap("<leader>F", ":SearchInHome<cr>") -- open file and edit
-- NeoTree
nnoremap("<leader>n", ":NeoTreeFocusToggle<cr>")
-- AsyncTask
nnoremap("<leader>eb", ":AsyncTask project-build<cr>")
nnoremap("<leader>er", ":AsyncTask project-run<cr>")
nnoremap("<leader>ee", ":call asyncrun#quickfix_toggle(8)<cr>")
-- Spectre (search and replace in files)
local has_spectre, spectre = pcall(require, "spectre")
if has_wk then
	wk.register({
		["<leader>"] = {
			b = {
				name = "Close", -- optional group name
				a = { ":bufdo bd<cr>", "Close all buffers" },
				b = { ":bd!<cr>", "Close this buffer" },
			},
			c = {
				name = "Copy", -- optional group name
				l = { ':let @+=expand("%:p")<cr>', "Copy current buffer's absolute path" },
				c = { '"+yy', "Copy line to system clipboard" },
				s = { ":so %<cr>", "Source current buffer" },
			},
			s = {
				p = { ":so ~/.config/nvim/plugin/packer.lua<cr>:PackerSync<cr>", "Sync Plugins" },
			},
			r = {
				name = "Spectre", -- optional group name
				r = { spectre.open, "Search and Replace in files" },
				f = { spectre.open_file_search, "Replace in current file" },
				w = {
					function()
						spectre.open_visual({ select_word = true })
					end,
					"Search current word",
				},
			},
		},
		g = {
			c = {
				function()
					return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
				end,
				"Comment line(s)",
				expr = true,
				replace_keycodes = true,
			},
			l = { ":Git log<cr>", "Git log" },
		},
		["<c-left>"] = { ":vertical resize -5<cr>", "Decrease width" },
		["<c-right>"] = { ":vertical resize +5<cr>", "Increase width" },
		["<c-up>"] = { ":resize -5<cr>", "Decrease height" },
		["<c-down>"] = { ":resize +5<cr>", "Increase height" },
	}, { mode = "n" })
	wk.register({
		["<leader>"] = {
			r = {
				name = "Spectre", -- optional group name
				r = { spectre.open_visual, "Replace selection in files" },
				f = { spectre.open_file_search, "Replace in current file" },
			},
		},
		g = {
			c = { "<Plug>(comment_toggle_linewise_visual)", "Comment line(s)" },
		},
	}, { mode = "v" })
else
	-- without "which-key" plugin
	-- just in case I will deside to stop using which-key plugin

	-- copy current buffer's absolute path to clipboard
	nnoremap("<leader>cl", ':let @+=expand("%:p")<cr>')
	-- copy current line to system clipboard
	nnoremap("<leader>cc", '"+yy')
	-- source current buffer
	nnoremap("<leader>cs", ":so %<cr>")
	-- sorce packer's plugin list file and run PackerSync
	nnoremap("<leader>sp", ":so ~/.config/nvim/plugin/packer.lua<cr>:PackerSync<cr>")
	-- search and replace
	if has_spectre then
		nnoremap("<leader>rr", spectre.open)
		nnoremap("<leader>rw", function()
			-- search current word
			spectre.open_visual({ select_word = true })
		end)
		vnoremap("<leader>rr", spectre.open_visual)
		vnoremap("<leader>rf", spectre.open_file_search)
		nnoremap("<leader>rf", spectre.open_file_search)
	end
	-- Close all buffers
	nmap("<leader>ba", ":bufdo bd<cr>")
	-- Close the current buffer
	nmap("<leader>bb", ":bd!<cr>")
	-- Comment.nvim
	nnoremap("gcc", function()
		return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
	end, { expr = true })
	vnoremap("gc", "<Plug>(comment_toggle_linewise_visual)")
end
