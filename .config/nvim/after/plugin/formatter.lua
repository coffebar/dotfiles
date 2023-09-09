local installed, plugin = pcall(require, "formatter")
if not installed then
	return
end
local prettier = function(plugin)
	local args
	if plugin ~= nil then
		args = { "--plugin", vim.fn.expand(plugin), "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) }
	else
		args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) }
	end
	return {
		exe = "prettier",
		args = args,
		stdin = true,
		try_node_modules = true,
	}
end

local node_lib = "~/.node_modules/lib/node_modules/"

local prettierPHP = function()
	return prettier(node_lib .. "@prettier/plugin-php/src/index.js")
end

local prettierSH = function()
	local config = prettier(node_lib .. "prettier-plugin-sh/lib/index.js")
	table.insert(config.args, "--use-tabs")
	table.insert(config.args, "true")
	return config
end

local pythonConfig = function()
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
plugin.setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.OFF, -- disabled for auto-save feature
	-- All formatter configurations are opt-in
	filetype = {
		scss = { stylefmt },
		css = { stylefmt },
		json = { prettier },
		html = { prettier },
		javascript = { prettier },
		javascriptreact = { prettier },
		typescript = { prettier },
		typescriptreact = { prettier },
		php = { prettierPHP },
		python = { pythonConfig },
		sshconfig = { prettier },
		nginx = { prettier },
		dockerfile = { prettierSH },
		sh = { prettierSH },
		lua = { stylua },
	},
})
