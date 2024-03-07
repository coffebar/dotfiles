return {
  -- colorschemes
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    enabled = function()
      -- not in TTY
      return vim.env.TERM ~= "linux"
    end,
    config = function()
      local onedark = require("onedark")
      onedark.setup(require("coffebar.plugins.onedark"))
      onedark.load()
    end,
  },
  {
    "gruvbox-community/gruvbox",
    priority = 999,
    enabled = function()
      return vim.env.TERM == "linux"
    end,
    config = function()
      vim.o.termguicolors = false
      vim.o.background = "dark"
      vim.o.title = false
      vim.g.indent_blankline_enabled = false
      vim.cmd("colorscheme gruvbox")
    end,
  },
  { "Mofiqul/dracula.nvim", priority = 1 },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = require("coffebar.plugins.lualine"),
    event = { "VimEnter" },
  },
  -- i3 config syntax highlighting
  { "mboughaba/i3config.vim", lazy = true, ft = "i3config" },
  -- formatter
  {
    "mhartington/formatter.nvim",
    opts = require("coffebar.plugins.formatter"),
    priority = 20,
  },
  -- s-motion to search by 2 characters
  { "justinmk/vim-sneak", lazy = true, keys = { "S", "s" } },
  -- asynchronous completion framework
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("coffebar.plugins.lspconfig")
    end,
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-emoji",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-calc",
  "petertriho/cmp-git",
  -- ripgrep source for completion
  "lukas-reineke/cmp-rg",
  -- UI helper for LSP
  {
    "glepnir/lspsaga.nvim",
    opts = {
      lightbulb = {
        enable = false,
        enable_in_insert = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
    },
    event = "LspAttach",
  },
  -- shows LSP progress
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    lazy = true,
  },
  -- show notifications in the corner of the screen
  {
    "rcarriga/nvim-notify",
    init = function()
      vim.notify = require("notify")
    end,
  },
  -- project manager
  {
    "coffebar/neovim-project",
    opts = require("coffebar.plugins.neovim-project"),
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    priority = 100,
  },
  -- translator
  {
    "coffebar/crowtranslate.nvim",
    lazy = true,
    cmd = { "CrowTranslate" },
    opts = {
      language = "uk",
      mask = "[а-яА-Я]",
      default = "en",
      engine = "google", -- google, bing, libretranslate, lingva, yandex
    },
  },
  -- search counter
  { "google/vim-searchindex", lazy = true, keys = { "n", "N", "/" } },
  -- turn off highlighting when you are done searching
  { "romainl/vim-cool" },
  -- automatically save files
  { "Pocco81/AutoSave.nvim", opts = require("coffebar.plugins.auto-save"), priority = 40 },
  -- commenter (gc)
  {
    "numToStr/Comment.nvim",
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---Disable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        basic = false,
        extra = false,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
  },
  -- automatically close pairs such as (), {}, ""
  { "cohama/lexima.vim", priority = 2 },
  -- treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- python venv manager
  { "HallerPatrick/py_lsp.nvim", priority = 2 },
  -- keep visible current function declaration
  {
    "romgrk/nvim-treesitter-context",
    opts = require("coffebar.plugins.nvim-treesitter-context"),
  },
  -- nice highlighting for variables
  -- has a binding <a-n> <a-p> to move by matching words
  { "RRethy/vim-illuminate" },
  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm i && git reset --hard",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = "markdown",
    lazy = true,
  },
  -- cheat sheet
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
  },
  -- blank char visualization
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    init = function()
      -- vim.opt.list = true
      -- vim.opt.listchars:append("space:⋅")
      -- vim.opt.listchars:append("eol:↴")
    end,
    enabled = function()
      return vim.env.TERM ~= "linux"
    end,
    opts = {
      indent = { char = "▏" },
      exclude = {
        buftypes = {
          "help",
          "nofile",
          "prompt",
          "quickfix",
          "terminal",
        },
      },
      -- whitespace = { highlight = { "Whitespace", "NonText" } },
      -- show_end_of_line = true,
      -- space_char_blankline = " ",
    },
    priority = 70,
  },
  -- show debug info
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end,
  },
  -- tabline plugin with re-orderable, auto-sizing
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    opts = {
      exclude_ft = {},
      exclude_name = {},
      highlight_inactive_file_icons = true,
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    version = "^1.0.0", -- optional: only update when a new 1.x version is released
  },
  -- git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
    lazy = true,
    event = "BufRead",
  },
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "G", "Git", "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      -- "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
    },
    config = true,
    opts = {
      integrations = {
        telescope = false,
        diffview = true,
      },
    },
    lazy = true,
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewLog", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  },
  -- snippets
  { "rafamadriz/friendly-snippets" },
  -- tests
  {
    "klen/nvim-test",
    enabled = false,
    config = function()
      require("nvim-test").setup({})
    end,
  },
  -- generic way to handle build/run/test/deploy tasks
  {
    "skywind3000/asynctasks.vim",
    lazy = true,
    cmd = { "AsyncTask", "AsyncRun", "AsyncTaskEdit", "AsyncTaskList", "AsyncTaskLog" },
    -- async terminal task runner
    dependencies = { "skywind3000/asyncrun.vim" },
  },
  -- telescope related plugin
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
  -- tree viewer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = require("coffebar.plugins.neo-tree"),
    lazy = true,
    cmd = "Neotree",
  },
  -- wrapper around the Lua code formatter
  { "ckipp01/stylua-nvim", lazy = true, ft = "lua" },
  -- add or edit surrounding
  {
    "kylechui/nvim-surround",
    lazy = true,
    keys = { "cs", "ds", "ys" },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-surround").setup({})
    end,
  },
  -- transform Text Case
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
    end,
  },
  -- toggle Boolean
  {
    "nguyenvukhang/nvim-toggler",
    lazy = true,
    keys = { "<leader>i" },
    opts = { inverses = { ["0"] = "1" } },
  },
  -- toggle checkbox [X]
  {
    "ibutra/checkbox.nvim",
    lazy = true,
    keys = { "<leader>I" },
    config = function()
      vim.keymap.set("n", "<leader>I", require("checkbox").checkbox)
    end,
  },
  -- replace in files with regexp
  {
    "nvim-pack/nvim-spectre",
    lazy = true,
    cmd = { "Spectre" },
    opts = {
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffDelete",
      },
    },
  },
  -- CSS color visualization
  {
    "NvChad/nvim-colorizer.lua",
    lazy = true,
    opts = require("coffebar.plugins.nvim-colorizer"),
    ft = { "css", "scss", "sass", "html", "dosini", "yaml", "javascript", "typescript", "i3config" },
  },
  -- auto close tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- dim unused variables and functions using LSP and treesitter
  {
    "0oAstro/dim.lua",
    dependencies = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
  },
  -- bookmarks
  { "ThePrimeagen/harpoon", lazy = true },
  -- copy history
  {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require("neoclip").setup({
        enable_macro_history = false,
        keys = {
          telescope = {
            i = {
              select = "<cr>",
              delete = "<c-d>", -- delete an entry
              edit = "<c-e>", -- edit an entry
              custom = {},
            },
          },
          fzf = {},
        },
      })
    end,
  },
  -- Github copilot
  { "github/copilot.vim", lazy = true, event = "VeryLazy" },
  -- delete buffers without closing window layout;
  { "moll/vim-bbye", priority = 1 },
  -- Interactive real time Neovim scratchpad
  { "rafcamlet/nvim-luapad", lazy = true, cmd = "Luapad" },
  -- edit your filesystem like you edit text
  { "elihunter173/dirbuf.nvim", lazy = true, cmd = "Dirbuf" },
  -- highlight arguments
  { "m-demare/hlargs.nvim", main = "hlargs", opts = { color = "#ef9062" } },
  -- highlight changed text after Undo / Redo operations
  {
    "tzachar/highlight-undo.nvim",
    opts = {
      duration = 200,
      undo = { hlgroup = "HighlightUndo", mode = "n", lhs = "u", map = "undo", opts = {} },
      redo = { hlgroup = "HighlightUndo", mode = "n", lhs = "<C-r>", map = "redo", opts = {} },
      highlight_for_count = true,
    },
  },
  -- more features for the built-in terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shade_terminals = false, -- disable shading because it breaks the background consistency
    },
  },
  -- deployment via rsync and OpenSSH
  {
    "coffebar/transfer.nvim",
    lazy = true,
    cmd = { "TransferInit", "TransferRepeat", "DiffRemote", "TransferUpload", "TransferDownload", "TransferDirDiff" },
    opts = {},
  },
  -- change line number color based on the current Vim mode
  { "mawkler/modicator.nvim", opts = {} },
  -- jump through the changes in multiple files
  { "bloznelis/before.nvim", lazy = true, opts = { history_size = 10 }, event = "VeryLazy" },
}
