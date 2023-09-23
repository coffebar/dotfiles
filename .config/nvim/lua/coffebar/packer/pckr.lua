-- This file is not in use. I use Lazy.nvim
-- Pckr here just for testing purposes
--
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/lewis6991/pckr.nvim",
      pckr_path,
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

local plugins = {}
local use = function(plugin)
  table.insert(plugins, plugin)
end
require("coffebar.packer.plugins")(use)
require("pckr").add(plugins)
