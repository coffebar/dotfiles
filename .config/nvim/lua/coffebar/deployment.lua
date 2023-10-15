local M = {}

-- This is in development

function M.get_remote_path()
  local cwd = vim.loop.cwd()
  local local_file = vim.fn.expand("%:p")
  local config_file = cwd .. "/.nvim/deployment.lua"
  local file_exists = vim.fn.filereadable(config_file) == 1
  if not file_exists then
    vim.notify("No deployment config found", vim.log.levels.ERROR)
    return nil
  end
  local config = dofile(config_file)
  -- remove cwd from local file path
  local_file = local_file:gsub(cwd, ""):gsub("^/", "")

  for name, deployment in pairs(config) do
    local skip = false
    for _, excluded in pairs(deployment.excludedPaths) do
      if string.find(local_file, excluded, 1, true) then
        vim.notify("File is excluded from deployment on " .. name .. " by rule: " .. excluded)
        skip = true
      end
    end
    if not skip then
      for _, mapping in pairs(deployment.mappings) do
        local start, e = string.find(local_file, mapping["local"], 1, true)
        if start == 1 then
          local remote_file = string.sub(local_file, e + 1)
          remote_file = mapping["remote"] .. remote_file
          remote_file = remote_file:gsub("^//", "/")
          local remote_path = "scp://"
          if deployment.user then
            remote_path = remote_path .. deployment.user .. "@"
          end
          remote_path = remote_path .. deployment.host
          if deployment.port then
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

return M
