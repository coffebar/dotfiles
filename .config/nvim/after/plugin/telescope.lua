local installed, telescope = pcall(require, "telescope")
if not installed then
  return
end

telescope.setup({
  pickers = {
    find_files = {
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "!.git/*",
        "--ignore-file",
        "~/.gitignore",
      },
    },
  },
})

-- Extensions:

-- neoclip
local neoclip_installed, _ = pcall(require, "neoclip")
if neoclip_installed then
  telescope.load_extension("neoclip")
end
local textcase_installed, _ = pcall(require, "textcase")
if textcase_installed then
  telescope.load_extension("textcase")
end
-- custom extension to run shell scripts in project
-- output goes to quickfix list via AsyncRun
telescope.load_extension("run-sh")
