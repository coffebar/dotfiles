local prettier = function(args)
	local fname = vim.fn.shellescape(vim.api.nvim_buf_get_name(0), true)
	if args == nil or type(args) ~= "table" then
		args = { "--stdin-filepath", fname, "--ignore-path" }
	else
		table.insert(args, "--stdin-filepath")
		table.insert(args, fname)
		-- git-ignored files formatting is allowed
		table.insert(args, "--ignore-path")
	end

	return {
		exe = "prettier",
		args = args,
		stdin = true,
		try_node_modules = true,
	}
end

local function nodeModuleLibPath(package, file)
	-- get the escaped path to the file in the node_modules lib

	local nodeModulesPath = vim.fn.expand("~/.local/share/pnpm/global/5/node_modules/")
	local packageDir = nodeModulesPath .. package .. "/"
	local fname = packageDir .. file
	if vim.fn.isdirectory(packageDir) == 0 then
		-- package is not installed
		vim.notify("npm package " .. package .. " is not found in " .. nodeModulesPath, vim.log.levels.WARN)
	else
		if vim.fn.filereadable(fname) == 0 then
			-- filename or path changed when package was updated
			vim.notify(
				"npm package " .. package .. " version mismatch. Please review ~/.config/nvim/after/plugin/formatter.lua",
				vim.log.levels.WARN
			)
		end
	end
	-- return the escaped path to the file
	return vim.fn.shellescape(fname, true)
end

local prettierPluginPHP = nodeModuleLibPath("@prettier/plugin-php", "src/index.js")
local prettierPHP = function()
	return prettier({ "--plugin", prettierPluginPHP })
end

local prettierPluginSH = nodeModuleLibPath("prettier-plugin-sh", "lib/index.js")
local prettierSH = function()
	return prettier({ "--use-tabs", "true", "--plugin", prettierPluginSH })
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
return {
	-- Enable or disable logging
	logging = false,
	-- Set the log level
	log_level = vim.log.levels.ERROR, -- disabled for auto-save feature
	-- All formatter configurations are opt-in
	filetype = {
		css = { stylefmt },
		dockerfile = { prettierSH },
		html = { prettier },
		javascript = { prettier },
		javascriptreact = { prettier },
		json = { prettier },
		lua = { stylua },
		nginx = { prettier },
		php = { prettierPHP },
		python = { pythonConfig },
		scss = { stylefmt },
		sh = { prettierSH },
		sshconfig = { prettier },
		typescript = { prettier },
		typescriptreact = { prettier },
		yaml = { prettier },
	},
}
