local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })
local au = vim.api.nvim_create_autocmd

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
end, {})

au("BufReadPost", {
  group = augroup,
  desc = "Return to last edit position when opening files",
  command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif',
})

au("BufReadPost", {
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

  if vim.fn.isdirectory(git_dir) ~= 1 then
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
    return
  end

  local in_dotfiles = function()
    local cwd = vim.loop.cwd()
    if vim.startswith(cwd, home .. "/.config/") or cwd == home or cwd == home .. "/.local/bin" then
      return true
    end
    return false
  end

  if in_dotfiles() then
    if vim.env.GIT_DIR == nil then
      -- export git location into ENV
      vim.env.GIT_DIR = git_dir
      vim.env.GIT_WORK_TREE = home
      return
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
au("BufReadPre", {
  desc = "Disable filetype for large files (>200KB)",
  command = 'let f=expand("<afile>") | if getfsize(f) > 200*1024 | set eventignore+=FileType | else | set eventignore-=FileType | endif',
  group = augroup,
})

-- Auto formatting
au("BufWritePost", {
  pattern = { "*.scss", "*.lua", "*.html" },
  desc = "Format files on write",
  callback = function()
    vim.api.nvim_command("FormatWrite")
  end,
  group = augroup,
})

-- Highlight yanked text
au("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ on_visual = false, timeout = 150 })
  end,
  group = augroup,
})

-- Git commit spell checking
au("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
  group = augroup,
})

-- Close diffview on q
au("FileType", {
  pattern = { "DiffviewFileHistory" },
  desc = "Close diffview on q",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>DiffviewClose<cr>", { buffer = true, silent = true })
  end,
  group = augroup,
})

-- Close special buffers on q
au("FileType", {
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

au("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  desc = "Disable line numbers in terminal",
  group = augroup,
})

au("DirChanged", {
  pattern = { "*" },
  group = augroup,
  desc = "defined in lua/coffebar/commands.lua",
  callback = function()
    update_git_env_for_dotfiles()
  end,
})

au("User", {
  pattern = { "SessionLoadPost" },
  group = augroup,
  desc = "Update git env for dotfiles",
  callback = function()
    update_git_env_for_dotfiles()
    -- restart lsp server for PHP to reload includePaths
    vim.api.nvim_command("silent! LspRestart intelephense")
  end,
})
