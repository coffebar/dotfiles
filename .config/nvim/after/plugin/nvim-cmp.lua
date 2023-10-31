-- Set up nvim-cmp (completion engine plugin)
local cmp_installed, cmp = pcall(require, "cmp")
if not cmp_installed then
  return
end
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
require("cmp_git").setup({})

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

-- ripgrep source for completion
local ripgrep = {
  name = "rg",
  keyword_length = 3,
  option = {
    additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/ignore.rg",
  },
}

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" }, -- nvim lua function
    { name = "path" },
    { name = "buffer" },
    { name = "calc" },
    ripgrep,
    { name = "emoji", priority = 10 },
    { name = "nvim_lsp_signature_help" },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        git = "[G]",
        latex_symbols = "[LaTeX]",
        nvim_lsp_signature_help = "[Signature]",
        gh_issues = "[Issues]",
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
        tmux = "[Tmux]",
        look = "[Look]",
        rg = "[RG]",
        crates = "[Crates]",
        orgmode = "[ORG]",
        dap = "[DAP]",
        npm = "[NPM]",
      })[entry.source.name]
      if entry.source.name == "nvim_lsp" then
        -- remove duplicates
        vim_item.dup = 0
      end
      return vim_item
    end,
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "git" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    ripgrep,
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.sort_text,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

cmp.setup.filetype("html", {
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- main
    { name = "luasnip" },
    { name = "nvim_lua" }, -- nvim lua function
    { name = "path" },
    { name = "buffer" },
    ripgrep,
  }),
  sorting = {
    comparators = {
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})
