-- Telescope extension
-- Find *.sh files in current directory and subdirectory
-- to run selected via AsyncRun plugin

local has_telescope, telescope = pcall(require, "telescope")

-- Ripgrep is required for this extension

if not has_telescope then
  return
end

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local function create_finder()
  local results = vim.fn.systemlist("rg --max-depth=2 --hidden --files --sortr modified --glob '*.sh'")
  local displayer = entry_display.create({ separator = " ", items = { { width = 30 }, { remaining = true } } })

  local function make_display(entry)
    return displayer({ entry.name })
  end

  return finders.new_table({
    results = results,
    entry_maker = function(entry)
      return { display = make_display, name = entry, value = entry, ordinal = entry }
    end,
  })
end

local function open_source(prompt_bufnr)
  local selection = state.get_selected_entry()
  actions.close(prompt_bufnr)
  if selection == nil then
    return
  end
  vim.api.nvim_command("edit " .. selection.value)
end

local function run(opts)
  opts = opts or {}

  pickers
    .new(opts, {
      prompt_title = "Run Shell Script",
      finder = create_finder(),
      previewer = false,
      sorter = telescope_config.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        -- Ctrl+o to review a file (open to edit)
        map("i", "<c-o>", open_source)

        local on_selected = function()
          local selection = state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection == nil then
            return
          end
          -- run AsyncRun shell Script
          vim.api.nvim_command("AsyncRun /usr/bin/sh " .. vim.fn.shellescape(selection.value))
        end
        actions.select_default:replace(on_selected)
        return true
      end,
    })
    :find()
end

return telescope.register_extension({
  exports = {
    ["run-sh"] = run,
  },
})
