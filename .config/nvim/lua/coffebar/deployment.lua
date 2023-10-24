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
    vim.notify("No deployment config found in \n" .. config_file, vim.log.levels.ERROR, {
      title = "Error",
      icon = " ",
      timeout = 4000,
    })
    return nil
  end
  local config = dofile(config_file)
  -- remove cwd from local file path
  path = path:gsub(cwd, ""):gsub("^/", "")

  local skip_reason
  for name, deployment in pairs(config) do
    local skip = false
    for _, excluded in pairs(deployment.excludedPaths) do
      if string.find(path, excluded, 1, true) then
        skip_reason = "File is excluded from deployment on " .. name .. " by rule: " .. excluded
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
  if skip_reason == nil then
    skip_reason = "File is not mapped in deployment config"
  end
  vim.notify(skip_reason, vim.log.levels.ERROR, {
    title = "No matches found",
    icon = " ",
    timeout = 4000,
  })
  return nil
end

local function reload_buffer(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype == "neo-tree" then
    require("neo-tree.command").execute({
      action = "refresh",
    })
    return
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.api.nvim_command("edit")
    end)
  end
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
-- @param local_path string|nil
function M.upload_file(local_path)
  if local_path == nil then
    local_path = vim.fn.expand("%:p")
  else
    local_path = vim.fn.fnamemodify(local_path, ":p")
  end
  local remote_path = M.get_remote_path(local_path)
  if remote_path == nil then
    return
  end
  local local_short = vim.fn.fnamemodify(local_path, ":~"):gsub(".*/", "")
  local stderr = {}
  local notification = vim.notify(local_short, vim.log.levels.INFO, {
    title = "Uploading file...",
    timeout = 0,
    icon = "󱕌 ",
  })
  local replace
  if notification ~= nil and notification.Record then
    replace = notification.Record
  end
  vim.fn.jobstart({ "scp", local_path, remote_path }, {
    on_stderr = function(_, data, _)
      if data == nil or #data == 0 then
        return
      end
      vim.list_extend(stderr, data)
    end,
    on_exit = function(_, code, _)
      if code == 0 then
        vim.notify(remote_path, vim.log.levels.INFO, {
          title = "File uploaded",
          icon = "",
          timeout = 3000,
          replace = replace,
        })
      else
        vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR, {
          title = "Error uploading file",
          timeout = 4000,
          replace = replace,
        })
      end
    end,
  })
end

-- Replace local file with remote copy
-- @param local_path string|nil
function M.download_file(local_path)
  if local_path == nil then
    local_path = vim.fn.expand("%:p")
  else
    local_path = vim.fn.fnamemodify(local_path, ":p")
  end
  local remote_path = M.get_remote_path(local_path)
  if remote_path == nil then
    return
  end
  local local_short = vim.fn.fnamemodify(local_path, ":~"):gsub(".*/", "")

  local notification = vim.notify(local_short, vim.log.levels.INFO, {
    title = "Downloading file...",
    timeout = 0,
    icon = "󱕉 ",
  })
  local replace
  if notification ~= nil and notification.Record then
    replace = notification.Record
  end
  local stderr = {}
  vim.fn.jobstart({ "scp", remote_path, local_path }, {
    on_stderr = function(_, data, _)
      if data == nil or #data == 0 then
        return
      end
      vim.list_extend(stderr, data)
    end,
    on_exit = function(_, code, _)
      if code == 0 then
        vim.notify(remote_path, vim.log.levels.INFO, {
          title = "Remote file downloaded",
          icon = "",
          timeout = 1000,
          replace = replace,
        })
        -- reload buffer for the downloaded file
        local bufnr = vim.fn.bufnr(local_path)
        if bufnr ~= -1 then
          reload_buffer(bufnr)
        end
      else
        vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR, {
          title = "Error downloading file",
          timeout = 4000,
          replace = replace,
        })
      end
    end,
  })
end

-- Get remote path for local directory
-- @param local_dir string
-- @return string
local function remote_path_for_rsync(local_dir)
  local remote_path = M.get_remote_path(local_dir)
  if remote_path == nil then
    return
  end
  -- remove scp:// prefix from path
  remote_path = remote_path:gsub("^scp://", "")
  -- replace only the first occurrence of / with :
  remote_path = remote_path:gsub("/", ":", 1)
  return remote_path
end

-- Show list of different [local/remote] files in the quickfix list
-- @param dir string
function M.show_dir_diff(dir)
  local remote_path = remote_path_for_rsync(dir)
  if remote_path == nil then
    return
  end

  local cmd = { "rsync", "-rlzi", "--dry-run", "--checksum", "--delete", "--out-format=%n" }
  local lines = { " " .. table.concat(cmd, " ") }
  vim.list_extend(cmd, { dir .. "/", remote_path .. "/" })

  -- remove cwd from dir path to show in short format
  dir = dir:gsub(vim.loop.cwd(), ""):gsub("^/", "")

  local notification = vim.notify("rsync -rlzi --dry-run --checksum --delete", vim.log.levels.INFO, {
    title = " Diff started...",
    timeout = 3500,
  })
  local replace
  if notification ~= nil and notification.Record then
    replace = notification.Record
  end
  vim.list_extend(lines, { dir, remote_path, "------" })
  local output = {}
  local stderr = {}
  vim.fn.jobstart(cmd, {
    on_stderr = function(_, data, _)
      if data == nil or #data == 0 then
        return
      end
      vim.list_extend(stderr, data)
    end,
    on_stdout = function(_, data, _)
      for _, line in pairs(data) do
        if line ~= "" then
          line = line:gsub("^deleting ", " ")
          table.insert(output, line)
        end
      end
    end,
    on_exit = function(_, code, _)
      if code ~= 0 then
        vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR, {
          timeout = 10000,
          title = "Error running rsync",
          replace = replace,
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

-- Sync local and remote directory
-- @param dir string
-- @param upload boolean
function M.sync_dir(dir, upload)
  local remote_path = remote_path_for_rsync(dir)
  if remote_path == nil then
    return
  end

  local cmd = { "rsync", "-rlzi", "--delete", "--checksum" }
  if upload then
    vim.list_extend(cmd, {
      "--exclude",
      ".git",
      "--exclude",
      ".idea",
      "--exclude",
      ".DS_Store",
      "--exclude",
      ".nvim",
      "--exclude",
      "*.pyc",
      dir .. "/",
      remote_path .. "/",
    })
  else
    vim.list_extend(cmd, {
      "--exclude",
      ".git",
      remote_path .. "/",
      dir .. "/",
    })
  end

  local notification = vim.notify("rsync -rlzi --delete --checksum", vim.log.levels.INFO, {
    title = " Sync started...",
    timeout = 5000,
  })
  local replace
  if notification ~= nil and notification.Record then
    replace = notification.Record
  end
  local output = {}
  local stderr = {}
  vim.fn.jobstart(cmd, {
    on_stderr = function(_, data, _)
      if data == nil or #data == 0 then
        return
      end
      vim.list_extend(stderr, data)
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
        vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR, {
          timeout = 10000,
          title = "Error running rsync",
          replace = replace,
        })
        return
      end

      if not upload then
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if filetype == "neo-tree" then
          reload_buffer(0)
        end
        -- reload all buffers in the synced directory
        local buffers = vim.api.nvim_list_bufs()
        for _, bufnr in pairs(buffers) do
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname ~= "" and bufname:find(dir, 1, true) then
            reload_buffer(bufnr)
          end
        end
      end

      if #output == 0 then
        vim.notify(" No differences found", vim.log.levels.INFO, {
          timeout = 3000,
          title = "Sync completed",
          replace = replace,
        })
        return
      end
      vim.notify(table.concat(output, "\n"), vim.log.levels.INFO, {
        timeout = 3000,
        title = "Sync completed",
        icon = " ",
        replace = replace,
      })
    end,
  })
end

return M
