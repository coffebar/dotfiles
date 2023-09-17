local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_installed, lazy = pcall(require, "lazy")
if not lazy_installed then
  return
end

local opts = {
  defaults = { lazy = false, version = nil, cond = nil },
  dev = { path = "~/pets", patterns = { "coffebar" }, fallback = true },
  install = { missing = true },
}

lazy.setup(require("coffebar.plugins"), opts)
