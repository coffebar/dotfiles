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
  wk.add({
    { "0", "^", desc = "Go to the first not empty character" },
    { "<a-0>", "<cmd>BufferLast<cr>", desc = "Go to the last tab" },
    { "<a-1>", "<cmd>BufferGoto 1<cr>", desc = "Go to 1 tab" },
    { "<a-2>", "<cmd>BufferGoto 2<cr>", desc = "Go to 2 tab" },
    { "<a-3>", "<cmd>BufferGoto 3<cr>", desc = "Go to 3 tab" },
    { "<a-4>", "<cmd>BufferGoto 4<cr>", desc = "Go to 4 tab" },
    { "<a-5>", "<cmd>BufferGoto 5<cr>", desc = "Go to 5 tab" },
    { "<a-6>", "<cmd>BufferGoto 6<cr>", desc = "Go to 6 tab" },
    { "<a-7>", "<cmd>BufferGoto 7<cr>", desc = "Go to 7 tab" },
    { "<a-8>", "<cmd>BufferGoto 8<cr>", desc = "Go to 8 tab" },
    { "<a-9>", "<cmd>BufferLast<cr>", desc = "Go to the last tab" },
    { "<c-\\>", "<cmd>q<cr>", desc = "Close window" },
    { "<c-b>", "<cmd>BufferPick<cr>", desc = "Go to buffer" },
    { "<c-d>", "<c-d>zz0", desc = "Scroll down" },
    { "<c-down>", "<cmd>resize +5<cr>", desc = "Increase height" },
    { "<c-e>", "<cmd>Dirbuf<cr>", desc = "Dirbuf" },
    { "<c-left>", "<cmd>vertical resize -5<cr>", desc = "Decrease width" },
    { "<c-p>", '<esc>"+p', desc = "Paste from the system clipboard" },
    { "<c-right>", "<cmd>vertical resize +5<cr>", desc = "Increase width" },
    { "<c-u>", "<c-u>zz0", desc = "Scroll up" },
    { "<c-up>", "<cmd>resize -5<cr>", desc = "Decrease height" },
    { "<leader>;", "<esc>A;<esc>", desc = "Add ';' to the end of line" },
    { "<leader><", "<cmd>BufferMovePrevious<cr>", desc = "Move tab left (barbar)" },
    {
      "<leader><leader>p",
      function()
        vim.api.nvim_command(vim.v.count .. "NeovimProjectLoadRecent")
      end,
      desc = "Open recent projects",
    },
    { "<leader>>", "<cmd>BufferMoveNext<cr>", desc = "Move tab right (barbar)" },
    { "<leader>F", "<cmd>SearchInHome<cr>", desc = "Search files in $HOME" },
    { "<leader>I", desc = "Toggle checkbox" },
    { "<leader>N", "<cmd>Neotree reveal<cr>", desc = "Reveal Neotree" },
    { "<leader>O", "O<esc>", desc = "Add blank line above" },
    { "<leader>P", "<cmd>NeovimProjectDiscover<cr>", desc = "Discover Project" },
    { "<leader>T", "<cmd>Trouble diagnostics<cr>", desc = "Trouble" },
    { "<leader>a", "<cmd>qa!<cr>", desc = "Quit" },
    { "<leader>b", "<cmd>Bdelete<cr>", desc = "Close this buffer" },
    { "<leader>c", group = "Copy" },
    { "<leader>cc", '"+yy', desc = "Copy line to system clipboard" },
    { "<leader>cf", "<cmd>%y+<cr>", desc = "Copy file content to system clipboard" },
    { "<leader>cl", '<cmd>let @+=expand("%:p")<cr>', desc = "Copy current buffer's absolute path" },
    { "<leader>cs", "<cmd>so %<cr>", desc = "Source current buffer" },
    { "<leader>e", group = "Run" },
    { "<leader>eb", "<cmd>AsyncTask project-build<cr>", desc = "./build.sh" },
    { "<leader>ed", "<cmd>AsyncTask project-deploy<cr>", desc = "./deploy.sh" },
    { "<leader>ee", "<cmd>copen 15<cr>", desc = "Show quickfix" },
    { "<leader>er", "<cmd>Telescope run-sh<cr>", desc = "Run sh script in the project dir" },
    { "<leader>ew", "<cmd>AsyncRun -silent alacritty -e ./watch.sh &<cr>", desc = "./watch.sh in `alacritty`" },
    { "<leader>f", group = "Telescope" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    {
      "<leader>fg",
      ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
      desc = "Live Grep (args)",
    },
    { "<leader>fh", "<cmd>Telescope command_history<cr>", desc = "Command_history" },
    { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    { "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>fs", "<cmd>Telescope git_files<cr>", desc = "Git status" },
    { "<leader>g", group = "Git" },
    { "<leader>gB", gitsigns.toggle_current_line_blame, desc = "Toggle current line blame" },
    {
      "<leader>gD",
      function()
        gitsigns.diffthis("~")
      end,
      desc = "Diff this with ~",
    },
    { "<leader>gR", gitsigns.reset_buffer, desc = "Reset buffer" },
    { "<leader>gS", gitsigns.stage_buffer, desc = "Stage buffer" },
    { "<leader>ga", "<cmd>G add -f %<cr>", desc = "Add current file to git" },
    {
      "<leader>gb",
      function()
        gitsigns.blame_line({ full = true })
      end,
      desc = "Show blame for current line",
    },
    { "<leader>gc", "<cmd>Git commit -v<cr>", desc = "Git commit" },
    { "<leader>gd", gitsigns.diffthis, desc = "Diff this" },
    { "<leader>gg", "<cmd>vert Git<cr>", desc = "Git" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "History for current file" },
    { "<leader>gl", "<cmd>Flog -date=short<cr>", desc = "Git log (Flog)" },
    {
      "<leader>gp",
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
      desc = "Push",
    },
    { "<leader>gr", gitsigns.reset_hunk, desc = "Reset hunk" },
    { "<leader>gs", gitsigns.stage_hunk, desc = "Stage hunk" },
    { "<leader>gt", gitsigns.toggle_deleted, desc = "toggle_deleted " },
    { "<leader>gu", gitsigns.undo_stage_hunk, desc = "Undo stage hunk" },
    { "<leader>gv", gitsigns.preview_hunk, desc = "preview hunk" },
    { "<leader>h", "<cmd>BufferPrevious<cr>", desc = "Previous tab (barbar)" },
    { "<leader>i", desc = "Toggle boolean" },
    { "<leader>j", group = "Jump" },
    {
      "<leader>jj",
      function()
        require("before").jump_to_last_edit()
      end,
      desc = "Jump to last edit",
    },
    {
      "<leader>jk",
      function()
        require("before").jump_to_next_edit()
      end,
      desc = "Jump to last edit (reverse)",
    },
    { "<leader>l", "<cmd>BufferNext<cr>", desc = "Next tab (barbar)" },
    { "<leader>n", "<cmd>Neotree focus toggle<cr>", desc = "Toggle Neotree" },
    { "<leader>o", "o<esc>", desc = "Add blank line below" },
    { "<leader>p", "<cmd>NeovimProjectHistory<cr>", desc = "Project from history" },
    { "<leader>r", group = "Replace" },
    { "<leader>rf", '<cmd>lua require("spectre").open_file_search()<cr>', desc = "Replace in current file" },
    { "<leader>rr", '<cmd>lua require("spectre").open()<cr>', desc = "Search and Replace in files" },
    {
      "<leader>rw",
      function()
        require("spectre").open_visual({ select_word = true })
      end,
      desc = "Search current word",
    },
    { "<leader>s", group = "..." },
    { "<leader>sl", "<cmd>Lazy<cr>", desc = "Lazy" },
    { "<leader>sp", "<cmd>Lazy sync<cr>", desc = "Sync Plugins" },
    { "<leader>t", group = "Tab / Terminal" },
    { "<leader>ta", "<cmd>AsyncRun -silent alacritty &<cr>", desc = "New alacritty Window" },
    { "<leader>tc", "<cmd>tabclose<cr>", desc = "Close tab" },
    { "<leader>tj", "<cmd>tabprev<cr>", desc = "Previous tab" },
    { "<leader>tk", "<cmd>tabnext<cr>", desc = "Next tab" },
    { "<leader>tn", "<cmd>tabnew<cr>", desc = "New tab" },
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
    { "<leader>u", group = "Upload / Download", icon = "" },
    {
      "<leader>ud",
      "<cmd>TransferDownload<cr>",
      desc = "Download from remote server (scp)",
      icon = { color = "green", icon = "󰇚" },
    },
    {
      "<leader>uf",
      "<cmd>DiffRemote<cr>",
      desc = "Diff file with remote server (scp)",
      icon = { color = "green", icon = "" },
    },
    {
      "<leader>ui",
      "<cmd>TransferInit<cr>",
      desc = "Init/Edit Deployment config",
      icon = { color = "green", icon = "" },
    },
    {
      "<leader>ur",
      "<cmd>TransferRepeat<cr>",
      desc = "Repeat transfer command",
      icon = { color = "green", icon = "󰑖" },
    },
    {
      "<leader>uu",
      "<cmd>TransferUpload<cr>",
      desc = "Upload to remote server (scp)",
      icon = { color = "green", icon = "󰕒" },
    },
    { "<leader>v", group = "Paste" },
    { "<leader>vf", '<cmd>%d<cr>"+P', desc = "Paste file content from system clipboard" },
    { "<leader>w", "<cmd>w!<cr>", desc = "Save file" },
    { "<leader>x", "<cmd>silent !chmod +x %<cr>", desc = "Make file executable" },
    { "=", "<cmd>Format<cr>", desc = "Format file" },
    {
      "[c",
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gitsigns.prev_hunk()
        end)
        return "<Ignore>"
      end,
      desc = "Previous hunk",
      expr = true,
      replace_keycodes = true,
    },
    {
      "]c",
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end,
      desc = "Next hunk",
      expr = true,
      replace_keycodes = true,
    },
    { "g", group = "Git" },
    {
      "gF",
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
      desc = "Create/Edit a file under cursor",
    },
    { "gaa", "<cmd>TextCaseOpenTelescope<cr>", desc = "Text Case (Telescope)" },
    {
      "gc",
      function()
        return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
      end,
      desc = "Comment line(s)",
      expr = true,
      replace_keycodes = true,
    },
    { "gl", "<cmd>Git log<cr>", desc = "Git log" },
    {
      "gp",
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
      desc = "Pull",
    },
    { "x", '"_x', desc = "Don't yank when press x" },
  })

  -- Visual mode -------------------------------------

  wk.add({
    {
      mode = { "v" },
      { "<c-c>", '"+y', desc = "Copy to the system clipboard" },
      { "<c-p>", '"+p', desc = "Paste from the system clipboard" },
      { "<leader>r", group = "Spectre" },
      { "<leader>rf", '<cmd>lua require("spectre").open_file_search()<cr>', desc = "Replace in current file" },
      { "<leader>rr", '<cmd>lua require("spectre").open_visual()<cr>', desc = "Replace selection in files" },
      { "gaa", "<cmd>TextCaseOpenTelescope<cr>", desc = "Text Case (Telescope)" },
      { "gc", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment line(s)" },
      { "s", '"fy<esc><cmd>let @/=@f[:-2]<cr><cmd>%s//\\=@0/gI<cr>', desc = "Replace selected text with Yanked" },
    },
  })

  -- Insert mode -------------------------------------
  wk.add({
    {
      mode = { "i" },
      { "<c-v>", '<esc>"+p', desc = "Paste from the system clipboard" },
      { "<leader>;", "<esc>A;<esc>", desc = "Add ';' to the end of line" },
      { "jk", "<esc>", desc = "Exit insert mode" },
      { "kj", "<esc>", desc = "Exit insert mode" },
    },
  })

  -- Terminal mode -------------------------------------
  wk.add({
    {
      mode = { "t" },
      { "<c-\\>", "<c-\\><c-n><cmd>bd!<cr>", desc = "Close terminal" },
      { "<c-d>", "<c-\\><c-n><cmd>q!<cr>", desc = "Close terminal" },
      { "<esc>", "<c-\\><c-n>", desc = "Exit terminal insert mode" },
      { "jk", "<c-\\><c-n><c-w>k", desc = "Exit terminal's insert mode" },
      { "kj", "<c-\\><c-n><c-w>k", desc = "Exit terminal's insert mode" },
    },
  })

  -- Select mode -------------------------------------
  wk.add({
    -- Keep yank register untouched when pasting text over selection
    { "p", '"_dP', desc = "Paste over selection", mode = "x" },
    { "T", "<cmd>CrowTranslate<cr>", desc = "Translate selected text", mode = "x" },
  })

  local lvg_args_installed, shortcuts = pcall(require, "telescope-live-grep-args.shortcuts")
  if lvg_args_installed then
    wk.add({
      "<leader>fg",
      shortcuts.grep_visual_selection,
      desc = "Grep search for selection",
      mode = "x",
    })
  end
else
  -- without "which-key" plugin
  -- if it fails to load for some reason
  require("coffebar.keymap-fallback")
end
