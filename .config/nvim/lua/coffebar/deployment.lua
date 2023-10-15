local M = {}

-- Deployment config example
--`.nvim/deployment.lua`
--
-- return {
--   ["server1"] = {
--     host = "server1",
--     username = "web", -- optional
--     port = 9202, -- optional
--     mappings = {
--       {
--         ["local"] = "domains/example.com",
--         ["remote"] = "/var/www/example.com",
--       },
--     },
--     excludedPaths = {
--       "src",
--     },
--   },
-- }

-- Get remote path for local file
function M.get_remote_path(path)
  local cwd = vim.loop.cwd()
  local config_file = cwd .. "/.nvim/deployment.lua"
  local file_exists = vim.fn.filereadable(config_file) == 1
  if not file_exists then
    vim.notify("No deployment config found", vim.log.levels.ERROR)
    return nil
  end
  local config = dofile(config_file)
  -- remove cwd from local file path
  path = path:gsub(cwd, ""):gsub("^/", "")

  for name, deployment in pairs(config) do
    local skip = false
    for _, excluded in pairs(deployment.excludedPaths) do
      if string.find(path, excluded, 1, true) then
        vim.notify("File is excluded from deployment on " .. name .. " by rule: " .. excluded)
        skip = true
      end
    end
    if not skip then
      for _, mapping in pairs(deployment.mappings) do
        local start, e = string.find(path, mapping["local"], 1, true)
        if start == 1 then
          local remote_file = string.sub(path, e + 1)
          remote_file = mapping["remote"] .. remote_file
          remote_file = remote_file:gsub("^//", "/")
          local remote_path = "scp://"
          if deployment.username then
            remote_path = remote_path .. deployment.username .. "@"
          end
          remote_path = remote_path .. deployment.host
          if deployment.port and deployment.port ~= 22 then
            remote_path = remote_path .. ":" .. deployment.port
          end
          remote_path = remote_path .. "/" .. remote_file
          return remote_path
        end
      end
    end
  end
  vim.notify("No matches found in deployment config")
  return nil
end

-- Open diff of local and remote file
function M.open_diff()
  local remote_path = M.get_remote_path(vim.fn.expand("%:p"))
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
  })

  vim.api.nvim_command("silent! diffsplit " .. remote_path)
end

-- Upload current file to remote server
function M.upload_file()
  local remote_path = M.get_remote_path(vim.fn.expand("%:p"))
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
end

-- Replace local file with remote copy
function M.download_file()
  local remote_path = M.get_remote_path(vim.fn.expand("%:p"))
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
end

-- Show list of different local-remote files in the quickfix list
function M.show_dir_diff(dir)
  local remote_path = M.get_remote_path(dir)
  if remote_path == nil then
    return
  end
  -- remove scp:// prefix from path
  remote_path = remote_path:gsub("^scp://", "")
  -- replace only the first occurence of / with :
  remote_path = remote_path:gsub("/", ":", 1)

  local cmd = { "rsync", "-rlzi", "--dry-run", "--checksum", "--out-format=%n" }
  local lines = { " " .. table.concat(cmd, " ") }
  vim.list_extend(cmd, { dir .. "/", remote_path .. "/" })

  -- remove cwd from dir path to show in short format
  dir = dir:gsub(vim.loop.cwd(), ""):gsub("^/", "")

  vim.notify("rsync", vim.log.levels.INFO, {
    title = " Diff started...",
    timeout = 3500,
  })
  vim.list_extend(lines, { dir, remote_path, "------" })
  local output = {}
  vim.fn.jobstart(cmd, {
    on_stderr = function(_, data, _)
      vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR, {
        timeout = 10000,
      })
    end,
    on_stdout = function(_, data, _)
      for _, line in pairs(data) do
        if line ~= "" then
          table.insert(output, line)
        end
      end
    end,
    on_exit = function(_, code, _)
      if code ~= 0 then
        vim.notify("Error running rsync", vim.log.levels.ERROR, {
          timeout = 10000,
        })
        return
      end
      if #output == 0 then
        table.insert(lines, " No differences found")
      else
        for _, line in pairs(output) do
          table.insert(lines, line)
        end
      end
      -- show quickfix list
      vim.fn.setqflist({}, "r", { title = "Diff: " .. dir, lines = lines })
      vim.api.nvim_command("copen")
    end,
  })
end

return M
