require("coffebar.commands")
require("coffebar.opt")

-- plugins
--
-- keep multiple plugin managers to test my plugins
local plugins_manager
plugins_manager = "coffebar.packer.pckr"
plugins_manager = "coffebar.packer.packer"
plugins_manager = "coffebar.lazy"

if plugins_manager ~= "coffebar.packer.packer" then
  local remove_file = vim.fn.expand("~/.config/nvim/plugin/packer_compiled.lua")
  if vim.fn.filereadable(remove_file) == 1 then
    vim.cmd("silent !rm -f " .. remove_file)
  end
end

require(plugins_manager)

-- keymap goes after mapleader and after plugins
require("coffebar.keymap")
require("coffebar.filetype")
