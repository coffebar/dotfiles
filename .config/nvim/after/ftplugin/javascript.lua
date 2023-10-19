if vim.fn.executable("uglifyjs") == 1 then
  vim.keymap.set("n", "<leader>=", ":silent !uglifyjs -c -m -o '%' '%'<cr>", { buffer = true })
end
