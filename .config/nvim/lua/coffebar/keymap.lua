-- keymap documentation plugin
--
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
      blame_line = gitsigns_is_not_installed,
      diffthis = gitsigns_is_not_installed,
      next_hunk = gitsigns_is_not_installed,
      prev_hunk = gitsigns_is_not_installed,
      preview_hunk = gitsigns_is_not_installed,
      reset_buffer = gitsigns_is_not_installed,
      reset_hunk = gitsigns_is_not_installed,
      stage_buffer = gitsigns_is_not_installed,
      stage_hunk = gitsigns_is_not_installed,
      toggle_current_line_blame = gitsigns_is_not_installed,
      toggle_deleted = gitsigns_is_not_installed,
      undo_stage_hunk = gitsigns_is_not_installed,
    }
  end

  -- Normal mode -------------------------------------

  wk.register({
    ["0"] = { "^", "Go to the first not empty character" },
    ["="] = { "<cmd>Format<cr>", "Format file" },

    -- Leader
    ["<leader>"] = {
      -- close all buffers and quit, session will be saved by "neovim-project"
      a = { "<cmd>qa!<cr>", "Quit" },
      -- say bye to the current buffer
      b = { "<cmd>Bdelete<cr>", "Close this buffer" },
      c = {
        name = "Copy", -- group name
        f = { "<cmd>%y+<cr>", "Copy file content to system clipboard" },
        l = { '<cmd>let @+=expand("%:p")<cr>', "Copy current buffer's absolute path" },
        c = { '"+yy', "Copy line to system clipboard" },
        r = { "<cmd>Telescope neoclip<cr>", "Neoclip" },
        s = { "<cmd>so %<cr>", "Source current buffer" },
      },
      e = {
        name = "Run",
        b = { "<cmd>AsyncTask project-build<cr>", "./build.sh" },
        d = { "<cmd>AsyncTask project-deploy<cr>", "./deploy.sh" },
        e = { "<cmd>copen 15<cr>", "Show quickfix" },
        -- see lua/telescope/_extensions/run-sh.lua
        r = { "<cmd>Telescope run-sh<cr>", "Run sh script in the project dir" },
        w = {
          "<cmd>AsyncRun -silent " .. terminal .. " -e ./watch.sh &<cr>",
          "./watch.sh in `" .. terminal .. "`",
        },
      },
      -- mapped by nguyenvukhang/nvim-toggler
      i = { "Toggle boolean" },
      -- mapped by ibutra/checkbox.nvim
      I = { "Toggle checkbox" },
      j = {
        name = "Jump",
        j = {
          function()
            require("before").jump_to_last_edit()
          end,
          "Jump to last edit",
        },
        k = {
          function()
            require("before").jump_to_next_edit()
          end,
          "Jump to last edit (reverse)",
        },
      },
      g = {
        name = "Git",
        a = { "<cmd>G add -f %<cr>", "Add current file to git" },
        b = {
          function()
            gitsigns.blame_line({ full = true })
          end,
          "Show blame for current line",
        },
        B = { gitsigns.toggle_current_line_blame, "Toggle current line blame" },
        c = { "<cmd>Git commit -v<cr>", "Git commit" },
        d = { gitsigns.diffthis, "Diff this" },
        D = {
          function()
            gitsigns.diffthis("~")
          end,
          "Diff this with ~",
        },
        h = { "<cmd>DiffviewFileHistory %<cr>", "History for current file" },
        g = { "<cmd>vert Git<cr>", "Git" },

        l = { "<cmd>Flog -date=short<cr>", "Git log (Flog)" },
        r = { gitsigns.reset_hunk, "Reset hunk" },
        R = { gitsigns.reset_buffer, "Reset buffer" },
        u = { gitsigns.undo_stage_hunk, "Undo stage hunk" },
        p = {
          function()
            require("coffebar.jobstart").run({
              cmd = "git push",
              start_title = "Pushing",
              start_message = "Loading...",
              start_icon = " ",
              success_title = "Pushed successfully",
              success_icon = " ",
              success_timeout = 1500,
              error_title = "Push failed",
              error_icon = " ",
              error_timeout = 7000,
            })
          end,
          "Push",
        },
        t = { gitsigns.toggle_deleted, "toggle_deleted " },
        s = { gitsigns.stage_hunk, "Stage hunk" },
        S = { gitsigns.stage_buffer, "Stage buffer" },
        v = { gitsigns.preview_hunk, "preview hunk" },
      },
      u = {
        name = "Upload / Download",
        d = { "<cmd>TransferDownload<cr>", "Download from remote server (scp)" },
        u = { "<cmd>TransferUpload<cr>", "Upload to remote server (scp)" },
        f = { "<cmd>DiffRemote<cr>", "Diff file with remote server (scp)" },
        i = { "<cmd>TransferInit<cr>", "Init/Edit Deployment config" },
        r = { "<cmd>TransferRepeat<cr>", "Repeat transfer command" },
      },
      n = { "<cmd>Neotree focus toggle<cr>", "Toggle Neotree" },
      N = { "<cmd>Neotree reveal<cr>", "Reveal Neotree" },
      p = { "<cmd>Telescope neovim-project history<cr>", "Project from history" },
      P = { "<cmd>Telescope neovim-project discover<cr>", "Discover Project" },
      t = {
        name = "Tab / Terminal",
        a = { "<cmd>AsyncRun -silent " .. terminal .. " &<cr>", "New " .. terminal .. " Window" },
        n = { "<cmd>tabnew<cr>", "New tab" },
        c = { "<cmd>tabclose<cr>", "Close tab" },
        j = { "<cmd>tabprev<cr>", "Previous tab" },
        k = { "<cmd>tabnext<cr>", "Next tab" },
        t = { "<cmd>ToggleTerm<cr>", "Terminal" },
      },
      T = { "<cmd>TroubleToggle<cr>", "Trouble" },
      F = { "<cmd>SearchInHome<cr>", "Search files in $HOME" },
      h = { "<cmd>BufferPrevious<cr>", "Previous tab (barbar)" },
      l = { "<cmd>BufferNext<cr>", "Next tab (barbar)" },
      ["<"] = { "<cmd>BufferMovePrevious<cr>", "Move tab left (barbar)" },
      [">"] = { "<cmd>BufferMoveNext<cr>", "Move tab right (barbar)" },
      f = {
        name = "Telescope",
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Live Grep (args)" },
        h = { "<cmd>Telescope command_history<cr>", "Command_history" },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
        r = { "<cmd>Telescope registers<cr>", "Registers" },
        s = { "<cmd>Telescope git_files<cr>", "Git status" },
      },
      s = {
        name = "...",
        p = { "<cmd>Lazy sync<cr>", "Sync Plugins" },
        l = { "<cmd>Lazy<cr>", "Lazy" },
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
      p = {
        function()
          require("coffebar.jobstart").run({
            cmd = "git pull",
            start_title = "Pulling",
            start_message = "Loading...",
            start_icon = " ",
            success_title = "git pull finished",
            success_icon = " ",
            success_timeout = 1500,
            error_title = "Pull failed",
            error_icon = " ",
            error_timeout = 7000,
          })
        end,
        "Pull",
      },
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
    T = { "<cmd>CrowTranslate<cr>", "Translate selected text" },
  }, { mode = "x" })

  local lvg_args_installed, shortcuts = pcall(require, "telescope-live-grep-args.shortcuts")
  if lvg_args_installed then
    wk.register({
      ["<leader>"] = {
        fg = { shortcuts.grep_visual_selection, "Grep search for selection" },
      },
    }, { mode = "x" })
  end
else
  -- without "which-key" plugin
  -- if it fails to load for some reason
  require("coffebar.keymap-fallback")
end
