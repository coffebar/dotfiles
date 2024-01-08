local prettier = function(args)
  local fname = vim.fn.shellescape(vim.api.nvim_buf_get_name(0), true)
  if args == nil or type(args) ~= "table" then
    args = { "--stdin-filepath", fname, "--ignore-path" }
  else
    table.insert(args, "--stdin-filepath")
    table.insert(args, fname)
    -- git-ignored files formatting is allowed
    table.insert(args, "--ignore-path")
  end
  return { exe = "prettier", args = args, stdin = true, try_node_modules = true }
end

local function nodeModuleLibPath(package, file)
  -- get the escaped path to the file in the node_modules lib
  local nodeModulesPath = vim.fn.expand("~/.local/share/pnpm/global/5/node_modules/")
  local packageDir = nodeModulesPath .. package .. "/"
  local fname = packageDir .. file
  if vim.fn.isdirectory(packageDir) == 0 then
    -- package is not installed
    vim.notify("npm package " .. package .. " is not found in " .. nodeModulesPath, vim.log.levels.WARN, {
      title = "formatter",
    })
  else
    if vim.fn.filereadable(fname) == 0 then
      -- filename or path changed when package was updated
      vim.notify(
        "npm package " .. package .. " version mismatch. Please review ~/.config/nvim/after/plugin/formatter.lua",
        vim.log.levels.WARN,
        { title = "formatter" }
      )
    end
  end
  -- return the escaped path to the file
  return vim.fn.shellescape(fname, true)
end

-- paths to the prettier plugins
local plugPath = {
  blade = nodeModuleLibPath("@shufo/prettier-plugin-blade", "dist/index.js"),
  nginx = nodeModuleLibPath("prettier-plugin-nginx", "dist/index.js"),
  php = nodeModuleLibPath("@prettier/plugin-php", "src/index.js"),
  sh = nodeModuleLibPath("prettier-plugin-sh", "lib/index.js"),
  ssh = nodeModuleLibPath("prettier-plugin-ssh-config", "lib/index.cjs"),
}

local prettify = {
  nginx = function()
    return prettier({ "--tab-width", "2", "--parser", "nginx", "--plugin", plugPath.nginx })
  end,
  php = function()
    local fname = vim.api.nvim_buf_get_name(0)
    local args
    if string.match(fname, "%.blade%.php") then
      args = { "--plugin", plugPath.blade, "--parser", "blade", "--tab-width", "2" }
    else
      args = { "--plugin", plugPath.php }
    end
    return prettier(args)
  end,
  sh = function()
    return prettier({ "--use-tabs", "true", "--plugin", plugPath.sh })
  end,
  ssh = function()
    return prettier({ "--parser", "ssh-config", "--use-tabs", "--plugin", plugPath.ssh })
  end,
}

local pythonConfig = function()
  return {
    exe = "autopep8",
    args = { "-" },
    stdin = true,
  }
end

local stylua = function()
  return { exe = "stylua", stdin = false, try_node_modules = true }
end

local stylefmt = function()
  return { exe = "stylefmt", stdin = true, try_node_modules = true }
end

local rustfmt = function()
  return { exe = "rustfmt", stdin = true, try_node_modules = false }
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
return {
  -- Enable or disable logging
  logging = false,
  -- Set the log level
  log_level = vim.log.levels.DEBUG, -- disabled for auto-save feature
  -- All formatter configurations are opt-in
  filetype = {
    css = { stylefmt },
    dockerfile = { prettify.sh },
    html = { prettier },
    javascript = { prettier },
    javascriptreact = { prettier },
    json = { prettier },
    lua = { stylua },
    markdown = { prettier },
    nginx = { prettify.nginx },
    php = { prettify.php },
    python = { pythonConfig },
    rust = { rustfmt },
    scss = { stylefmt },
    sh = { prettify.sh },
    sshconfig = { prettify.ssh },
    typescript = { prettier },
    typescriptreact = { prettier },
    yaml = { prettier },
    ["yaml.ansible"] = { prettier },

    -- Format with LSP if there are not other formatters
    -- or format with prettier if there are no LSP formatters
    ["*"] = {
      function()
        local formatters = require("formatter.util").get_available_formatters_for_ft(vim.bo.filetype)
        if #formatters > 0 then
          return
        end
        -- check if there are any LSP formatters
        for _, client in pairs(vim.lsp.buf_get_clients()) do
          if client.server_capabilities.document_formatting then
            -- format with LSP
            vim.lsp.buf.formatting()
            return
          end
        end
        -- default to prettier
        return prettier()
      end,
    },
  },
}
