local prettierConfig = function()
	return {
		exe = "prettier",
		args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) },
		stdin = true,
		try_node_modules = true,
	}
end

local autopep8Config = function()
	return {
		exe = "autopep8",
		args = { "-" },
		stdin = true,
	}
end

local stylua = function()
	return { exe = "stylua", stdin = false, try_node_modules = true }
end

local stylefmt = function()
	return { exe = "stylefmt", stdin = true, try_node_modules = true }
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.OFF, -- disabled for auto-save feature
	-- All formatter configurations are opt-in
	filetype = {
		scss = { stylefmt },
		css = { stylefmt },
		json = { prettierConfig },
		html = { prettierConfig },
		javascript = { prettierConfig },
		javascriptreact = { prettierConfig },
		typescript = { prettierConfig },
		typescriptreact = { prettierConfig },
		php = { prettierConfig },
		python = { autopep8Config },
		sshconfig = { prettierConfig },
		nginx = { prettierConfig },
		lua = { stylua },
	},
})
