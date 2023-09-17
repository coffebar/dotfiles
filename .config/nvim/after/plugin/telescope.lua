local installed, telescope = pcall(require, "telescope")
if not installed then
  return
end
local telescopeConfig = require("telescope.config")
local actions = require("telescope.actions")
local mappings = require("telescope.mappings")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!.git/*")

local changed_mappings = mappings.default_mappings
-- map Ctrl+f instead of Ctrl+q, because Ctrl+q will close my terminal
changed_mappings["i"]["<C-f>"] = actions.send_to_qflist + actions.open_qflist

telescope.setup({
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
  },
  pickers = {
    find_files = {
      mappings = changed_mappings,
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "!.git/*",
        "--ignore-file",
        "~/.gitignore",
      },
      --
    },
    live_grep = {
      mappings = changed_mappings,
    },
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
})

-- Extensions:

-- nvim-telescope/telescope-file-browser.nvim
telescope.load_extension("file_browser")
-- neoclip
local neoclip_installed, _ = pcall(require, "neoclip")
if neoclip_installed then
  telescope.load_extension("neoclip")
end
local textcase_installed, _ = pcall(require, "textcase")
if textcase_installed then
  telescope.load_extension("textcase")
end
