local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

vim.api.nvim_create_user_command("SearchInHome", function()
  require("telescope.builtin").find_files({
    cwd = "~",
    find_command = {
      "rg",
      "--files",
      "--hidden",
      "--one-file-system",
      "--ignore-file",
      ".config/nvim/ignore.rg",
      "--max-depth",
      "7",
    },
  })
end, { nargs = 0 })

vim.api.nvim_create_user_command("DiffRemote", function()
  local deployment = require("coffebar.deployment")
  local remote_path = deployment.get_remote_path(vim.fn.expand("%:p"))
  if remote_path == nil then
    return
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { remote_path },
    desc = "Add mapping to close diffview",
    once = true,
    callback = function()
      vim.keymap.set("n", "<leader>b", "<cmd>diffoff | bd!<cr>", { buffer = true })
    end,
    group = augroup,
  })

  vim.api.nvim_command("silent! diffsplit " .. remote_path)
end, { nargs = 0 })

vim.api.nvim_create_user_command("CopyToRemote", function()
  local deployment = require("coffebar.deployment")
  local remote_path = deployment.get_remote_path(vim.fn.expand("%:p"))
  if remote_path == nil then
    return
  end
  vim.fn.jobstart({ "scp", vim.fn.expand("%:p"), remote_path }, {
    on_stderr = function(_, data, _)
      vim.notify(table.concat(data, "\n"))
    end,
    on_stdout = function(_, data, _)
      vim.notify(table.concat(data, "\n"))
    end,
    on_exit = function(_, code, _)
      if code == 0 then
        print("Uploaded: " .. remote_path)
      else
        vim.notify("Error uploading " .. remote_path, vim.log.levels.ERROR)
      end
    end,
  })
end, { nargs = 0 })

vim.api.nvim_create_user_command("CopyFromRemote", function()
  local deployment = require("coffebar.deployment")
  local remote_path = deployment.get_remote_path(vim.fn.expand("%:p"))
  if remote_path == nil then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.jobstart({ "scp", remote_path, vim.fn.expand("%:p") }, {
    on_stderr = function(_, data, _)
      vim.notify(table.concat(data, "\n"))
    end,
    on_stdout = function(_, data, _)
      vim.notify(table.concat(data, "\n"))
    end,
    on_exit = function(_, code, _)
      if code == 0 then
        print("Downloaded: " .. remote_path)
        -- reload buffer
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_call(bufnr, function()
            vim.api.nvim_command("edit")
          end)
        end
      else
        vim.notify("Error downloading " .. remote_path, vim.log.levels.ERROR)
      end
    end,
  })
end, { nargs = 0 })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Return to last edit position when opening files",
  command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif',
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Set expandtab false if file has tabs or filetype is sh",
  callback = function(arg)
    -- smart indenting
    -- don't expand tabs for these filetypes
    local format_with_tabs = { "sh", "sshconfig", "dockerfile" }
    -- check if file has tabs for other filetypes

    local has_tabs = function(bufnr)
      -- Search for tabs in buffer
      if vim.fn.executable("rg") == 0 then
        return false
      end
      local result = vim.fn.systemlist({
        "rg", -- Note: just changing `rg` to `grep` will not work
        "--only-matching",
        "--no-heading",
        "--max-count",
        "1",
        "\t",
      }, bufnr)
      return #result > 0
    end

    local filetype = vim.api.nvim_buf_get_option(arg.buf, "filetype")
    -- skip if filetype is binary or buffer is invalid
    if filetype == "binary" or not vim.api.nvim_buf_is_valid(arg.buf) then
      return
    end

    if vim.tbl_contains(format_with_tabs, filetype) or has_tabs(arg.buf) then
      vim.api.nvim_buf_set_option(arg.buf, "expandtab", false)
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif" },
  desc = "Open images in external viewer-editor",
  callback = function()
    local image_viewers = {
      -- first found program will be used to open image
      "pix", -- https://github.com/linuxmint/pix
      "feh",
    }
    -- search for installed program
    for _, program in ipairs(image_viewers) do
      if vim.fn.executable(program) == 1 then
        local file = vim.fn.expand("%:p")
        vim.fn.jobstart({ program, file }, { detach = true })
        -- image buffer is not useful in binary representation.
        -- Will close buffer without closing a window
        vim.api.nvim_command("bp | sp | bn | bd")
        return
      end
    end
  end,
})

local function update_git_env_for_dotfiles()
  -- Auto change ENV variables to enable
  -- bare git repository for dotfiles after
  -- loading saved session
  local home = vim.fn.expand("~")
  local git_dir = home .. "/dotfiles"

  if vim.env.GIT_DIR ~= nil and vim.env.GIT_DIR ~= git_dir then
    return
  end

  -- check dotfiles dir exists on current machine
  if vim.fn.isdirectory(git_dir) ~= 1 then
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
    return
  end

  -- check if the current working directory should belong to dotfiles
  local cwd = vim.loop.cwd()
  if vim.startswith(cwd, home .. "/.config/") or cwd == home or cwd == home .. "/.local/bin" then
    if vim.env.GIT_DIR == nil then
      -- export git location into ENV
      vim.env.GIT_DIR = git_dir
      vim.env.GIT_WORK_TREE = home
    end
  else
    if vim.env.GIT_DIR == git_dir then
      -- unset variables
      vim.env.GIT_DIR = nil
      vim.env.GIT_WORK_TREE = nil
    end
  end
end

-- Optimize for large files
vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Disable filetype for large files (>200KB)",
  command = 'let f=expand("<afile>") | if getfsize(f) > 200*1024 | set eventignore+=FileType | else | set eventignore-=FileType | endif',
  group = augroup,
})

-- Auto formatting
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.scss", "*.lua", "*.html" },
  desc = "Format files on write",
  callback = function()
    vim.api.nvim_command("FormatWrite")
  end,
  group = augroup,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ on_visual = false, timeout = 150 })
  end,
  group = augroup,
})

-- Git commit spell checking
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
  group = augroup,
})

-- Close diffview on q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "DiffviewFileHistory" },
  desc = "Close diffview on q",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>DiffviewClose<cr>", { buffer = true, silent = true })
  end,
  group = augroup,
})

-- Close special buffers on q
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "checkhealth",
    "dirbuf",
    "floggraph",
    "fugitive",
    "fugitiveblame",
    "git",
    "help",
    "qf",
    "spectre_panel",
  },
  desc = "Close buffers on q",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>bdelete<cr>", { buffer = true, silent = true })
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  desc = "Disable line numbers in terminal",
  group = augroup,
})

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = { "*" },
  group = augroup,
  desc = "Update git env for dotfiles after changing directory",
  callback = function()
    update_git_env_for_dotfiles()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "SessionLoadPost" },
  group = augroup,
  desc = "Update git env for dotfiles after loading session",
  callback = function()
    update_git_env_for_dotfiles()
    -- restart lsp server for PHP to reload includePaths
    vim.api.nvim_command("silent! LspRestart intelephense")
  end,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true, buffer = ev.buf }
    -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gD", ":Lspsaga peek_definition<cr>", opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", ":Lspsaga hover_doc<cr>", opts)
    vim.keymap.set("n", "<leader>rn", ":Lspsaga rename<cr>", opts)
    vim.keymap.set("n", "gr", ":Lspsaga finder<cr>", opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", ":Lspsaga code_action<cr>", opts)

    -- get client name by id ev.data.client_id
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    vim.notify("LspAttach " .. client.name)

    -- Inlay Hints
    if vim.lsp.inlay_hint then
      if client.server_capabilities.inlayHintProvider == true then
        vim.lsp.inlay_hint(ev.buf, true)
        vim.keymap.set("n", "<leader>I", function()
          vim.lsp.inlay_hint(0, nil)
        end, opts)
      else
        vim.lsp.inlay_hint(ev.buf, false)
      end
    end
  end,
})
