local M = {}

---@class JobStartOpts
---@field cmd string|table
---@field start_title string
---@field start_message string
---@field start_icon string
---@field success_title string
---@field success_icon string
---@field success_timeout number
---@field error_title string
---@field error_icon string
---@field error_timeout number

-- Run a job in the background and show notifications during execution.
---@param opts JobStartOpts
---@return nil
function M.run(opts)
  local output = {}
  local notification = vim.notify(opts.start_message, vim.log.levels.INFO, {
    title = opts.start_title,
    icon = opts.start_icon,
    timeout = 0,
  })
  local replace
  if notification ~= nil and notification.Record then
    replace = notification.Record
  end
  vim.fn.jobstart(opts.cmd, {
    on_stderr = function(_, data)
      vim.list_extend(output, data)
    end,
    on_stdout = function(_, data)
      vim.list_extend(output, data)
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify(vim.trim(table.concat(output, "\n")), vim.log.levels.INFO, {
          title = opts.success_title,
          icon = opts.success_icon,
          timeout = opts.success_timeout,
          replace = replace,
        })
      else
        vim.notify(vim.trim(table.concat(output, "\n")), vim.log.levels.ERROR, {
          title = opts.error_title,
          icon = opts.error_icon,
          timeout = opts.error_timeout,
          replace = replace,
        })
      end
    end,
  })
end

return M
