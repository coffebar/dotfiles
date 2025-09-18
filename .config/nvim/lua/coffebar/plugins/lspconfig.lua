local py_lsp_installed, py_lsp = pcall(require, "py_lsp")

-- load snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- ansible
vim.lsp.config["ansiblels"] = {}

-- bash, requires bash-language-server
vim.lsp.config["bashls"] = {}

-- javascript linter, requires vscode-langservers-extracted
vim.lsp.config["eslint"] = {}

-- TypeScript/JavaScript and Vue configuration
-- Using ts_ls with @vue/typescript-plugin for Vue support
vim.lsp.config["ts_ls"] = {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.expand("~/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin"),
        languages = { "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
}

-- lua, requires lua-language-server
vim.lsp.config["lua_ls"] = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

-- css, html
-- requires vscode-langservers-extracted npm package
-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config["cssls"] = { capabilities = capabilities }
vim.lsp.config["html"] = { capabilities = capabilities }

vim.lsp.config["emmet_ls"] = {
  capabilities = capabilities,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "php", "vue" },
  init_options = {
    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts
  },
}

-- json
vim.lsp.config["jsonls"] = {
  capabilities = capabilities,
  provideFormatter = true,
}

-- go
vim.lsp.config["gopls"] = {}

-- php
vim.lsp.config["intelephense"] = {
  settings = {
    intelephense = {
      -- see https://github.com/bmewburn/intelephense-docs/blob/master/installation.md#initialisation-options
      environment = {
        phpVersion = "8.3.0",
      },
      files = {
        maxSize = 5000000, -- 5MB for stubs
      },
      telemetry = {
        enabled = false,
      },
      clearCache = true,
      stubs = {
        "apache",
        "bcmath",
        "bz2",
        "calendar",
        "com_dotnet",
        "Core",
        "ctype",
        "curl",
        "date",
        "dba",
        "dom",
        "enchant",
        "exif",
        "FFI",
        "fileinfo",
        "filter",
        "fpm",
        "ftp",
        "gd",
        "gettext",
        "gmp",
        "hash",
        "iconv",
        "imap",
        "intl",
        "json",
        "ldap",
        "libxml",
        "mbstring",
        "meta",
        "mysqli",
        "oci8",
        "odbc",
        "openssl",
        "pcntl",
        "pcre",
        "PDO",
        "pdo_ibm",
        "pdo_mysql",
        "pdo_pgsql",
        "pdo_sqlite",
        "pgsql",
        "Phar",
        "posix",
        "pspell",
        "readline",
        "Reflection",
        "session",
        "shmop",
        "SimpleXML",
        "snmp",
        "soap",
        "sockets",
        "sodium",
        "SPL",
        "sqlite3",
        "standard",
        "superglobals",
        "sysvmsg",
        "sysvsem",
        "sysvshm",
        "tidy",
        "tokenizer",
        "xml",
        "xmlreader",
        "xmlrpc",
        "xmlwriter",
        "xsl",
        "Zend OPcache",
        "zip",
        "zlib",
        -- addeditional stubs
        "wordpress",
      },
    },
  },
}

-- pyright lsp for python
vim.lsp.config["pyright"] = {}

-- rust, requires rust_analyzer
vim.lsp.config["rust_analyzer"] = {}

-- enable all servers
vim.lsp.enable({
  "ansiblels",
  "bashls",
  "eslint",
  "ts_ls",
  "lua_ls",
  "cssls",
  "html",
  "emmet_ls",
  "jsonls",
  "gopls",
  "intelephense",
  "pyright",
  "rust_analyzer",
})

if py_lsp_installed then
  local py_lsp_loaded = false
  local py_cwd = nil
  local augroup = vim.api.nvim_create_augroup("py_lsp", { clear = true })
  local function guess_venv_path()
    local venv_path = "venv"
    if vim.fn.isdirectory(venv_path) == 0 and vim.fn.isdirectory(".venv") then
      venv_path = ".venv"
    end
    return venv_path
  end
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
            default_venv_name = guess_venv_path(),
          })
        end, 500)
      else
        -- change venv if cwd changed since setup
        local cwd = vim.fn.getcwd()
        if cwd ~= py_cwd then
          vim.api.nvim_command("PyLspActivateVenv " .. guess_venv_path())
          py_cwd = cwd
        end
      end
    end,
  })
end
