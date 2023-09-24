vim.filetype.add({
  extension = {
    mjml = "html",
    ejs = "html",
    http = "rest",
    mts = "typescript",
    mtsx = "typescriptreact",
  },
  filename = {
    ["tsconfig.json"] = "jsonc",
    [".eslintrc"] = "json",
    ["go.mod"] = "gomod",
    ["i3config"] = "i3config",
    ["ignore.rg"] = "gitignore",
  },
  pattern = {
    ["^%.env%."] = "sh",
    ["%.webmanifest$"] = "json",
    -- ansible
    [".*/tasks/.*.ya?ml"] = "yaml.ansible",
    [".*/ansible/.*.ya?ml"] = "yaml.ansible",
  },
})
