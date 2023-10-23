local lsp_installed, lspconfig = pcall(require, "lspconfig")
if not lsp_installed then
  return
end

-- enable logging
-- vim.lsp.set_log_level("info")

local py_lsp_installed, py_lsp = pcall(require, "py_lsp")

-- load snippets
require("luasnip.loaders.from_vscode").lazy_load()

---------------- language servers ---------------------

--ansible
lspconfig.ansiblels.setup({})
-- bash, requires bash-language-server
lspconfig.bashls.setup({})
-- javascript linter, requires vscode-langservers-extracted
lspconfig.eslint.setup({})
lspconfig.tsserver.setup({})
-- lua, requires lua-language-server
lspconfig.lua_ls.setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
          telemetry = {
            enable = false,
          },
          hint = {
            enable = true,
          },
        },
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end,
})
-- css, html
-- requires vscode-langservers-extracted npm package
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "php" },
  init_options = {
    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts
  },
})
-- json
lspconfig.jsonls.setup({
  capabilities = capabilities,
  provideFormatter = true,
})
-- go
lspconfig.gopls.setup({})
-- php
lspconfig.intelephense.setup({
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          vim.fn.expand("~") .. "/.local/share/phpstorm-stubs",
          vim.fn.expand("~") .. "/.local/share/wordpress-stubs",
        },
        phpVersion = "8.2.0",
      },
      files = {
        maxSize = 5000000, -- 5MB for stubs
      },
      clearCache = true,
    },
  },
})
-- pyright lsp for python
lspconfig.pyright.setup({})

if py_lsp_installed then
  local py_lsp_loaded = false
  local py_cwd = nil
  local augroup = vim.api.nvim_create_augroup("py_lsp", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    pattern = { "*.py" },
    desc = "Lazy load py_lsp after *.py file opened and activate venv",
    callback = function()
      if not py_lsp_loaded then
        py_lsp_loaded = true
        py_cwd = vim.fn.getcwd()
        vim.defer_fn(function()
          -- python lsp with venv using pyrigth
          py_lsp.setup({
            host_python = "/bin/python3",
            language_server = "pyright",
            default_venv_name = "venv",
          })
        end, 500)
      else
        -- change venv if cwd changed since setup
        local cwd = vim.fn.getcwd()
        if cwd ~= py_cwd then
          vim.api.nvim_command("PyLspActivateVenv")
          py_cwd = cwd
        end
      end
    end,
  })
end

-- rust, requires rust_analyzer
lspconfig.rust_analyzer.setup({})
