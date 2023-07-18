local lspconfig = require("lspconfig")
local py_lsp = require("py_lsp")

require("lspsaga").setup({
	lightbulb = {
		enable = false,
		enable_in_insert = false,
	},
	symbol_in_winbar = {
		enable = false,
	},
})

-- setup nvim-ts-autotag
require("nvim-ts-autotag").setup()

-- fidget - UI for nvim-lsp progress
require("fidget").setup()

-- load snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "gr", ":Lspsaga finder<cr>", bufopts)
	vim.keymap.set("n", "<C-k>", ":Lspsaga hover_doc<cr>", bufopts)
	vim.keymap.set("n", "<leader>rn", ":Lspsaga rename<cr>", bufopts)
	vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<cr>", bufopts)
	vim.keymap.set("n", "gD", ":Lspsaga peek_definition<cr>", bufopts)

	-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	-- vim.keymap.set('n', '<space>wl', function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, bufopts)
	-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	-- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

	-- force to use Formatter plugin for this client
	local force_formatter = client.name == "lua_ls" or client.name == "tsserver" or client.name == "pyright"

	if client.name == "intelephense" then
		-- force use prettier for blade.php files, not for php
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if string.match(bufname, ".blade.php$") then
			force_formatter = true
		end
	end

	if client.server_capabilities.documentFormattingProvider and not force_formatter then
		vim.keymap.set("v", "=", function()
			vim.lsp.buf.format({})
		end, { silent = false })
		vim.keymap.set("n", "=", function()
			vim.lsp.buf.format({
				async = false,
				range = nil,
			})
		end, { silent = false })
	else
		vim.keymap.set("n", "=", ":Format<cr>", bufopts)
		vim.keymap.set("v", "=", ":Format<cr>", bufopts)
	end
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

-- language servers --

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
-- bash, requires bash-language-server
lspconfig.bashls.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})
-- javascript linter, requires vscode-langservers-extracted
lspconfig.eslint.setup({})
lspconfig.tsserver.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})
-- python, requires pyright
lspconfig.pyright.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})
-- python, plugin HallerPatrick/py_lsp.nvim
py_lsp.setup({
	on_attach = on_attach,
	host_python = "/bin/python3",
	language_server = "pyright",
	default_venv_name = "venv",
})
-- markdown, requires ltex-ls
lspconfig.ltex.setup({
	on_attach = on_attach,
	autostart = true,
	filetypes = { "markdown" },
	settings = {
		ltex = {
			disabledRules = {
				["en-US"] = {
					"ARROWS",
					"MORFOLOGIK_RULE_EN_US", --disable spell
				},
			},
			dictionary = {
				["en-US"] = ":" .. vim.fn.stdpath("config") .. "/spell/en.utf-8.add", -- doesn't work
			},
		},
	},
})
-- rust, requires rust_analyzer
lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

-- css, html
-- requires vscode-langservers-extracted npm package
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	flags = lsp_flags,
})
lspconfig.html.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	flags = lsp_flags,
	provideFormatter = true,
})
lspconfig.emmet_ls.setup({
	capabilities = capabilities,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
	init_options = {
		-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts
	},
})
-- json
lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	flags = lsp_flags,
	provideFormatter = true,
})
-- go
lspconfig.gopls.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})
-- php
lspconfig.intelephense.setup({
	on_attach = on_attach,
	flags = lsp_flags,
})
