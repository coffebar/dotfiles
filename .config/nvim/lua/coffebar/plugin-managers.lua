-- keep multiple plugin managers to test my plugins
local plugins_manager
plugins_manager = "coffebar.packer.pckr"
plugins_manager = "coffebar.packer.packer"
plugins_manager = "coffebar.lazy"

local home = vim.fn.expand("~")
local packer_path = home .. "/.local/share/nvim/site/pack/packer"
local packer_path_moved = home .. "/.local/share/nvim/.packer"
local is_dir = vim.fn.isdirectory
if plugins_manager == "coffebar.packer.packer" then
  if is_dir(packer_path) == 0 and is_dir(packer_path_moved) == 1 then
    vim.cmd("silent !mv " .. packer_path_moved .. " " .. packer_path)
  end
else
  local compiled_file = home .. "/.config/nvim/plugin/packer_compiled.lua"
  if vim.fn.filereadable(compiled_file) == 1 then
    vim.cmd("silent !rm -f " .. compiled_file)
    if is_dir(packer_path) == 1 and is_dir(packer_path_moved) == 0 then
      vim.cmd("silent !mv " .. packer_path .. " " .. packer_path_moved)
    end
  end
end

require(plugins_manager)
