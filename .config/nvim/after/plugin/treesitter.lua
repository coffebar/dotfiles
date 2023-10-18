local installed, configs = pcall(require, "nvim-treesitter.configs")
if not installed then
  return
end
-- disable slow treesitter for large files
local function disable_all(_, buf)
  local max_filesize = 200 * 1024 -- 200 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
  -- Disable treesitter for vim command mode (open with `q:`)
  if vim.api.nvim_get_mode().mode == "c" and vim.api.nvim_buf_get_option(buf, "filetype") == "vim" then
    return true
  end
end

---@diagnostic disable-next-line: missing-fields
configs.setup({
  ensure_installed = {
    "bash",
    "c",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "git_config",
    "gitcommit",
    "gitignore",
    "go",
    "gpg",
    "html",
    "ini",
    "javascript",
    "json",
    "kotlin",
    "lua",
    "markdown",
    "markdown_inline",
    "php",
    "phpdoc",
    "python",
    "rust",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vue",
    "xml",
    "yaml",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {},

  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    disable = disable_all,

    -- Setting this to true will run `:h syntax` and treesitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    disable = disable_all,
    keymaps = {
      init_selection = "<CR>",
      scope_incremental = "<CR>",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
  indent = {
    enable = true,
    disable = function(_, buf)
      local ftype = vim.api.nvim_buf_get_option(buf, "filetype")
      return ftype ~= "php" and ftype ~= "yaml.ansible"
    end,
  },
})
