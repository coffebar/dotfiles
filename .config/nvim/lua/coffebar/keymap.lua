-- keymap documentation plugin
local has_wk, wk = pcall(require, "which-key")
-- Spectre (search and replace in files)
local has_spectre, spectre = pcall(require, "spectre")
-- git integration
local _, gs = pcall(require, "gitsigns")
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

-- Fast saving
nnoremap("<leader>w", "<cmd>w!<cr>")
nnoremap("<leader>ц", "<cmd>w!<cr>")
-- press jk to exit from insert mode
inoremap("jk", "<Esc>")
inoremap("kj", "<Esc>")
-- copy to system clipboard by Ctrl+c in the Visual mode
vnoremap("<C-c>", '"+y')
-- paste in normal mode from system clipboard
vnoremap("<C-p>", '"+p')
nnoremap("<C-p>", '"+p')
inoremap("<C-p>", '<esc>"+p')

-- keep yank register untouched when pasting text over selection
xnoremap("p", '"_dP')

-- center cursor on scroll
nnoremap("<C-d>", "<C-d>zz0")
nnoremap("<C-u>", "<C-u>zz0")

-- quit
nnoremap("<leader>a", "<cmd>qa!<cr>")
nnoremap("<leader>ф", "<cmd>qa!<cr>")

nnoremap("Ф", "A")
nnoremap("Ш", "I")

-- open terminal in split below and start Insert mode
nnoremap("<leader>t", "<cmd>belowright split | resize 10 | terminal<cr>i")

-- terminal mode related
-- close terminal window
tnoremap("<C-d>", "<C-\\><C-n><cmd>q!<cr>")
-- exit terminal insert mode
tnoremap("<Esc>", "<C-\\><C-n>")
-- exit terminal's insert mode and go to upper window
tnoremap("jk", "<C-\\><C-n><C-w>k")
-- Ctrl+4 to close terminal window
tnoremap("<C-\\>", "<C-\\><C-n><cmd>bd!<cr>")

-- Ctrl+4 to close window and keep buffer
nnoremap("<C-\\>", "<cmd>q<cr>")
-- nnoremap("<leader>l", "<cmd>bnext<cr>")
-- nnoremap("<leader>h", "<cmd>bprevious<cr>")

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
-- Git
nnoremap("<leader>gs", "<cmd>Gitsigns stage_hunk<cr>")
nnoremap("<leader>gS", "<cmd>Gitsigns stage_buffer<cr>")
nnoremap("<leader>gr", "<cmd>Gitsigns reset_hunk<cr>")
nnoremap("<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>")
nnoremap("<leader>gR", "<cmd>Gitsigns reset_buffer<cr>")
nnoremap("<leader>gp", "<cmd>AsyncRun git push<cr>")
-- history for current file
nnoremap("<leader>gh", "<cmd>DiffviewFileHistory %<cr>")
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
-- AsyncTask
nnoremap("<leader>eb", "<cmd>AsyncTask project-build<cr>")
nnoremap("<leader>er", "<cmd>AsyncTask project-run<cr>")
nnoremap("<leader>ee", "<cmd>call asyncrun#quickfix_toggle(8)<cr>")
if has_wk then
  -- Normal mode
  wk.register({
    ["<leader>"] = {
      b = { "<cmd>Bdelete<cr>", "Close this buffer" },
      c = {
        name = "Copy", -- optional group name
        f = { "<cmd>%y+<cr>", "Copy file content to system clipboard" },
        l = { '<cmd>let @+=expand("%:p")<cr>', "Copy current buffer's absolute path" },
        c = { '"+yy', "Copy line to system clipboard" },
        p = { "<cmd>CccPick<cr>", "Color picker" },
        r = { "<cmd>Telescope neoclip<cr>", "Neoclip" },
        s = { "<cmd>so %<cr>", "Source current buffer" },
      },
      g = {
        name = "Git",
        a = { "<cmd>G add -f %<cr>", "Add current file to git" },
        b = {
          function()
            gs.blame_line({ full = true })
          end,
          "blame current line",
        },
        B = { gs.toggle_current_line_blame, "toggle current line blame" },
        d = { gs.diffthis, "diffthis" },
        D = {
          function()
            gs.diffthis("~")
          end,
          "diffthis ~",
        },
        t = { gs.toggle_deleted, "toggle_deleted " },
        v = { gs.preview_hunk, "preview hunk" },
      },
      p = { "<cmd>Telescope neovim-project history<cr>", "Project history" },
      P = { "<cmd>Telescope neovim-project discover<cr>", "Find Project " },
      h = { "<cmd>BufferPrevious<cr>", "Previous tab (barbar)" },
      l = { "<cmd>BufferNext<cr>", "Next tab (barbar)" },
      ["<"] = { "<cmd>BufferMovePrevious<cr>", "Move tab left (barbar)" },
      [">"] = { "<cmd>BufferMoveNext<cr>", "Move tab right (barbar)" },
      f = {
        name = "Telescope",
        b = { "<cmd>Telescope file_browser<cr>", "Telescope file_browser" },
        f = { "<cmd>Telescope find_files<cr>", "Telescope find_files" },
        g = { "<cmd>Telescope live_grep<cr>", "Telescope live_grep" },
        h = { "<cmd>Telescope command_history<cr>", "Telescope command_history" },
        j = { "<cmd>Telescope jumplist<cr>", "Telescope jumplist" },
        r = { "<cmd>Telescope registers<cr>", "Telescope registers" },
        s = { "<cmd>Telescope git_status<cr>", "Telescope git_status" },
      },
      s = {
        p = { "<cmd>Lazy sync<cr>", "Sync Plugins" },
        a = { "<cmd>AsyncRun -silent alacritty &<cr>", "New Alacritty Window" },
      },
      m = {
        name = "Harpoon",
        a = { require("harpoon.mark").add_file, "Add file to Harpoon" },
        m = { require("harpoon.ui").toggle_quick_menu, "Harpoon quick menu" },
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
      T = { "<cmd>TroubleToggle<cr>", "Trouble" },
      v = {
        name = "Paste",
        -- overwrite entire buffer's content from system clipboard
        f = { '<cmd>%d<cr>"+p', "Paste file content from system clipboard" },
      },
      x = { "<cmd>!chmod +x %<cr>", "Make file executable" },
    },
    ["<c-h>"] = { require("harpoon.ui").nav_prev, "Harpoon prev item" },
    ["<c-l>"] = { require("harpoon.ui").nav_next, "Harpoon prev item" },

    -- switch buffers by Alt+num (barbar)
    ["<a-1>"] = { "<cmd>BufferGoto 1<cr>", "Go to 1 tab" },
    ["<a-2>"] = { "<cmd>BufferGoto 2<cr>", "Go to 2 tab" },
    ["<a-3>"] = { "<cmd>BufferGoto 3<cr>", "Go to 3 tab" },
    ["<a-4>"] = { "<cmd>BufferGoto 4<cr>", "Go to 4 tab" },
    ["<a-5>"] = { "<cmd>BufferGoto 5<cr>", "Go to 5 tab" },
    ["<a-6>"] = { "<cmd>BufferGoto 6<cr>", "Go to 6 tab" },
    ["<a-7>"] = { "<cmd>BufferGoto 7<cr>", "Go to 7 tab" },
    ["<a-8>"] = { "<cmd>BufferGoto 8<cr>", "Go to 8 tab" },
    ["<a-9>"] = { "<cmd>BufferLast<cr>", "Go to the last tab" },
    ["<a-0>"] = { "<cmd>BufferLast<cr>", "Go to the last tab" },

    g = {
      aa = { "<cmd>TextCaseOpenTelescope<CR>", "Text Case (Telescope)" },
      c = {
        function()
          return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
            or "<Plug>(comment_toggle_linewise_count)"
        end,
        "Comment line(s)",
        expr = true,
        replace_keycodes = true,
      },
      l = { "<cmd>Git log<cr>", "Git log" },
      F = {
        function()
          local path = vim.fn.expand("<cfile>")
          if not string.find(path, "^[~/]") then
            -- prepend current file's dir
            local Path = require("plenary.path")
            local f = vim.fn.expand("%:h")
            path = Path:new(f .. "/", path)
          end
          vim.api.nvim_command("e " .. tostring(path))
        end,
        "Create/Edit a file under cursor",
      },
    },
    ["<c-left>"] = { "<cmd>vertical resize -5<cr>", "Decrease width" },
    ["<c-right>"] = { "<cmd>vertical resize +5<cr>", "Increase width" },
    ["<c-up>"] = { "<cmd>resize -5<cr>", "Decrease height" },
    ["<c-down>"] = { "<cmd>resize +5<cr>", "Increase height" },
    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Previous hunk",
      expr = true,
      replace_keycodes = true,
    },
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end,
      "Next hunk",
      expr = true,
      replace_keycodes = true,
    },
  }, { mode = "n" })
  -- Visual mode
  wk.register({
    ["<leader>"] = {
      r = {
        name = "Spectre", -- optional group name
        r = { spectre.open_visual, "Replace selection in files" },
        f = { spectre.open_file_search, "Replace in current file" },
      },
    },
    g = {
      aa = { "<cmd>TextCaseOpenTelescope<CR>", "Text Case (Telescope)" },
      c = { "<Plug>(comment_toggle_linewise_visual)", "Comment line(s)" },
    },
    -- s in visual mode to replace selected text with Yanked
    s = {
      -- yank selection into register F,
      -- copy from F to / (search register),
      -- substitute content of search register to text from the register 0
      -- [:-2] removes last char (2 bytes) from the end of variable
      '"fy<esc><cmd>let @/=@f[:-2]<cr><cmd>%s//\\=@0/gI<cr>',
      "Replace selected text with Yanked",
    },
  }, { mode = "v" })
else
  -- without "which-key" plugin
  -- just in case I will deside to stop using which-key plugin

  -- copy current buffer's absolute path to clipboard
  nnoremap("<leader>cl", '<cmd>let @+=expand("%:p")<cr>')
  -- plugin with Yank history
  nnoremap("<leader>cr", "<cmd>Telescope neoclip<cr>")
  -- copy current line to system clipboard
  nnoremap("<leader>cc", '"+yy')
  -- source current buffer
  nnoremap("<leader>cs", "<cmd>so %<cr>")
  -- install and update plugins
  nnoremap("<leader>sp", "<cmd>Lazy sync<cr>")
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
  -- Close the current buffer
  nnoremap("<leader>b", "<cmd>Bdelete<cr>")
  -- Comment.nvim
  nnoremap("gcc", function()
    return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
  end, { expr = true })
  vnoremap("gc", "<Plug>(comment_toggle_linewise_visual)")
end
