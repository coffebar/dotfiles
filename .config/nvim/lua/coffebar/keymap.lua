-- keymap documentation plugin
local has_wk, wk = pcall(require, "which-key")
if has_wk then
  local terminal = vim.env.TERMINAL
  if terminal == nil then
    terminal = "alacritty"
  end
  local _, gitsigns = pcall(require, "gitsigns")
  if gitsigns == nil then
    -- gitsigns is not installed or loaded
    local gitsigns_is_not_installed = function(_)
      vim.notify("gitsigns is not installed or loaded", vim.log.levels.WARN)
    end
    gitsigns = {
      toggle_current_line_blame = gitsigns_is_not_installed,
      diffthis = gitsigns_is_not_installed,
      toggle_deleted = gitsigns_is_not_installed,
      prev_hunk = gitsigns_is_not_installed,
      next_hunk = gitsigns_is_not_installed,
      blame_line = gitsigns_is_not_installed,
      preview_hunk = gitsigns_is_not_installed,
    }
  end

  -- Normal mode -------------------------------------

  wk.register({
    ["0"] = { "^", "Go to the first not empty character" },
    ["="] = { "<cmd>Format<cr>", "Format file" },

    -- Leader
    ["<leader>"] = {
      a = { "<cmd>qa!<cr>", "Quit" },
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
      e = {
        name = "Run",
        b = { "<cmd>AsyncTask project-build<cr>", "./build.sh" },
        d = { "<cmd>AsyncTask project-deploy<cr>", "./deploy.sh" },
        r = { "<cmd>Telescope run-sh<cr>", "Run sh script in the project dir" },
        w = {
          "<cmd>AsyncRun -silent " .. terminal .. " -e ./watch.sh &<cr>",
          "./watch.sh in `" .. terminal .. "`",
        },
        e = { "<cmd>copen 15<cr>", "Show quickfix" },
      },
      -- mapped by "nguyenvukhang/nvim-toggler"
      i = { "Toggle boolean" },
      g = {
        name = "Git",
        a = { "<cmd>G add -f %<cr>", "Add current file to git" },
        b = {
          function()
            gitsigns.blame_line({ full = true })
          end,
          "blame current line",
        },
        B = { gitsigns.toggle_current_line_blame, "toggle current line blame" },
        c = { "<cmd>Git commit -v<cr>", "Git commit" },
        d = { gitsigns.diffthis, "diffthis" },
        D = {
          function()
            gitsigns.diffthis("~")
          end,
          "diffthis ~",
        },
        h = { "<cmd>DiffviewFileHistory %<cr>", "History for current file" },
        g = { "<cmd>vert Git<cr>", "Git" },
        l = { "<cmd>Flog -date=short<cr>", "Git log (Flog)" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset buffer" },
        u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo stage hunk" },
        p = { "<cmd>AsyncRun git push<cr>", "Push" },
        t = { gitsigns.toggle_deleted, "toggle_deleted " },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
        S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage buffer" },
        v = { gitsigns.preview_hunk, "preview hunk" },
      },
      n = { "<cmd>Neotree focus toggle<cr>", "Toggle Neotree" },
      N = { "<cmd>Neotree reveal<cr>", "Reveal Neotree" },
      p = { "<cmd>Telescope neovim-project history<cr>", "Project from history" },
      P = { "<cmd>Telescope neovim-project discover<cr>", "Discover Project" },
      t = { "<cmd>belowright split | resize 10 | terminal<cr>i", "Builtin terminal" },
      T = { "<cmd>TroubleToggle<cr>", "Trouble" },
      F = { "<cmd>SearchInHome<cr>", "Search files in $HOME" },
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
        name = "...",
        p = { "<cmd>Lazy sync<cr>", "Sync Plugins" },
        a = { "<cmd>AsyncRun -silent " .. terminal .. " &<cr>", "New " .. terminal .. " Window" },
      },
      m = {
        name = "Harpoon",
        a = { require("harpoon.mark").add_file, "Add file to Harpoon" },
        m = { require("harpoon.ui").toggle_quick_menu, "Harpoon quick menu" },
      },
      o = { "o<esc>", "Add blank line below" },
      O = { "O<esc>", "Add blank line above" },
      r = {
        name = "Replace",
        r = { '<cmd>lua require("spectre").open()<cr>', "Search and Replace in files" },
        f = { '<cmd>lua require("spectre").open_file_search()<cr>', "Replace in current file" },
        w = {
          function()
            require("spectre").open_visual({ select_word = true })
          end,
          "Search current word",
        },
      },
      v = {
        name = "Paste",
        -- Overwrite entire buffer's content from system clipboard
        f = { '<cmd>%d<cr>"+P', "Paste file content from system clipboard" },
      },
      w = { "<cmd>w!<cr>", "Save file" },
      x = { "<cmd>silent !chmod +x %<cr>", "Make file executable" },
      [";"] = { "<esc>A;<esc>", "Add ';' to the end of line" },
    },
    ["<leader><leader>p"] = {
      function()
        vim.api.nvim_command(vim.v.count .. "NeovimProjectLoadRecent")
      end,
      "Open recent projects",
    },
    -- / end Leader (Normal mode)

    ["<c-h>"] = { require("harpoon.ui").nav_prev, "Harpoon prev item" },
    ["<c-l>"] = { require("harpoon.ui").nav_next, "Harpoon prev item" },
    ["<c-e>"] = { "<cmd>Dirbuf<cr>", "Dirbuf" },

    -- Switch buffers by Alt+num (barbar)
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
    ["<c-b>"] = { "<cmd>BufferPick<cr>", "Go to buffer" },

    g = {
      name = "Git",
      aa = { "<cmd>TextCaseOpenTelescope<cr>", "Text Case (Telescope)" },
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
      p = { "<cmd>AsyncRun git pull<cr>", "Pull" },
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

    x = { '"_x', "Don't yank when press x" },

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
          gitsigns.prev_hunk()
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
          gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end,
      "Next hunk",
      expr = true,
      replace_keycodes = true,
    },

    ["<c-p>"] = { '<esc>"+p', "Paste from the system clipboard" },
    -- Center cursor on scroll
    ["<c-d>"] = { "<c-d>zz0", "Scroll down" },
    ["<c-u>"] = { "<c-u>zz0", "Scroll up" },
    -- Ctrl+4 to close window
    ["<c-\\>"] = { "<cmd>q<cr>", "Close window" },
  }, { mode = "n" })

  -- Visual mode -------------------------------------

  wk.register({
    ["<leader>"] = {
      r = {
        name = "Spectre", -- optional group name
        r = { '<cmd>lua require("spectre").open_visual()<cr>', "Replace selection in files" },
        f = { '<cmd>lua require("spectre").open_file_search()<cr>', "Replace in current file" },
      },
    },
    g = {
      aa = { "<cmd>TextCaseOpenTelescope<cr>", "Text Case (Telescope)" },
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
    ["<c-c>"] = { '"+y', "Copy to the system clipboard" },
    ["<c-p>"] = { '"+p', "Paste from the system clipboard" },
  }, { mode = "v" })

  -- Insert mode -------------------------------------
  wk.register({
    jk = { "<esc>", "Exit insert mode" },
    kj = { "<esc>", "Exit insert mode" },
    ["<leader>"] = {
      [";"] = { "<esc>A;<esc>", "Add ';' to the end of line" },
    },
    ["<c-v>"] = { '<esc>"+p', "Paste from the system clipboard" },
  }, { mode = "i" })

  -- Terminal mode -------------------------------------
  wk.register({
    -- Exit terminal's insert mode and go to upper window
    jk = { "<c-\\><c-n><c-w>k", "Exit terminal's insert mode" },
    kj = { "<c-\\><c-n><c-w>k", "Exit terminal's insert mode" },
    -- Exit terminal insert mode
    ["<esc>"] = { "<c-\\><c-n>", "Exit terminal insert mode" },
    -- Close terminal window
    ["<c-d>"] = { "<c-\\><c-n><cmd>q!<cr>", "Close terminal" },
    -- Ctrl+4 to close terminal window
    ["<c-\\>"] = { "<c-\\><c-n><cmd>bd!<cr>", "Close terminal" },
  }, { mode = "t" })

  -- Select mode -------------------------------------
  wk.register({
    -- Keep yank register untouched when pasting text over selection
    p = { '"_dP', "Paste over selection" },
  }, { mode = "x" })
else
  -- without "which-key" plugin
  -- if it fails to load for some reason
  require("coffebar.keymap-fallback")
end
