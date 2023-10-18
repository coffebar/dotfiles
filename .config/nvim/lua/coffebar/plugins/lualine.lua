return {
  options = {
    icons_enabled = true,
    -- theme = "gruvbox-material",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "filename",
        file_status = true, -- Displays file status (readonly status, modified status)
        newfile_status = true, -- Display new file status (new file means no write after created)
        path = 3, -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory

        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
        -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = "[+]", -- Text to show when the file is modified.
          readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for new created file before first writting
        },
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype", "filesize" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {
    "neo-tree",
    "fugitive",
    "trouble",
    "quickfix",
  },
}
