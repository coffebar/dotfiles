local prettierConfig = function()
	return {
		exe = "prettier",
		args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
		stdin = true
	}
end

local stylefmt = function()
	return {
		exe = "stylefmt",
		stdin = true,
		try_node_modules = true,
	}
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {

		scss = { stylefmt },
		css = { stylefmt },
		json = { prettierConfig },
		html = { prettierConfig },
		javascript = { prettierConfig },
		typescript = { prettierConfig },
		typescriptreact = { prettierConfig },
		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		-- ["*"] = {
		-- 	require("formatter.filetypes.any").remove_trailing_whitespace
		-- }
	}
}
