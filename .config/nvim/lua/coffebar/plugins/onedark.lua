return {
  style = "warm",
  transparent = false, -- Show/hide background
  term_colors = false, -- Change terminal color as per the selected theme style

  -- toggle theme style ---
  -- toggle_style_key = "<leader>co", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  -- toggle_style_list = { "darker", "deep", "warmer" }, -- List of styles to toggle between
  lualine = {
    transparent = false, -- lualine center bar transparency
  },
  colors = {
    grey = "#8b8b8b",
    fg = "#bbbbbb",
    bg0 = "#2b2e37",
  },
  code_style = {
    comments = "none",
    keywords = "none",
    functions = "none",
    strings = "none",
    variables = "none",
  },
  highlights = {
    TreesitterContext = { fg = "$fg", bg = "$bg2" },
    CursorLine = { bg = "#2b3137" },
  },
}
