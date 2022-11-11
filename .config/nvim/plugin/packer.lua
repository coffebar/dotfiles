vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- plugins here

	-- statusline
	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })
	use({ "kyazdani42/nvim-web-devicons" })
	-- colorschemes
	use("gruvbox-community/gruvbox")
	-- i3 config syntax highlighting
	use("mboughaba/i3config.vim")
	-- formatter
	use("mhartington/formatter.nvim")
	-- s-motion to search by 2 characters
	use("justinmk/vim-sneak")
	-- fuzzy finder
	use({ "junegunn/fzf.vim", run = ":call fzf#install()" })
	-- lsp based tools
	use({ "glepnir/lspsaga.nvim", branch = "main" })
	-- asynchronous completion framework
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	-- ripgrep source for completion
	use("lukas-reineke/cmp-rg")
	-- project manager

	-- use {
	-- 	"ahmedkhalf/project.nvim",
	-- 	config = function()
	-- 		require("project_nvim").setup {
	-- 			-- configuration comes here
	-- 		}
	-- 	end
	-- }

	use({
		"coffebar/project.nvim",
		branch = "session-manager",
		config = function()
			require("project_nvim").setup({
				session_autoload = true,
				silent_chdir = false,
			})
		end,
	})
	-- search counter
	use("google/vim-searchindex")
	-- turn off highlighting when you are done searching
	use("romainl/vim-cool")
	-- automatically save files
	use("Pocco81/auto-save.nvim")
	-- commenter (gc)
	use("numToStr/Comment.nvim")
	-- automatically close pairs such as (), {}, ""
	use("cohama/lexima.vim")
	-- treesitter
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("romgrk/nvim-treesitter-context")
	-- nice highlighting for variables
	-- has a binding <a-n> <a-p> to move by matching words
	use("RRethy/vim-illuminate")
	-- markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
	-- help menu
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	-- blank char visualization
	use("lukas-reineke/indent-blankline.nvim")
	-- show debug info
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
		end,
	})
	-- bufferline - tabs with diagnostics indicator
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "kyazdani42/nvim-web-devicons" })
	-- git
	use({ "lewis6991/gitsigns.nvim" })
	use({ "tpope/vim-fugitive" })
	-- snippets
	use("rafamadriz/friendly-snippets")
	-- tests
	use({
		"klen/nvim-test",
		config = function()
			require("nvim-test").setup({})
		end,
	})
	-- generic way to handle build/run/test/deploy tasks
	use({
		"skywind3000/asynctasks.vim",
		-- async terminal task runner
		requires = { "skywind3000/asyncrun.vim" },
	})
	-- telescope fuzzy finder
	use({ "nvim-telescope/telescope.nvim", tag = "0.1.0", requires = { { "nvim-lua/plenary.nvim" } } })
	use("nvim-telescope/telescope-file-browser.nvim")
	-- tree viewer
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	})
	-- session manager
	use("Shatur/neovim-session-manager")
	-- wrapper around the Lua code formatter
	use("ckipp01/stylua-nvim")
	-- add or edit surrounding
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	})
	-- css color visualization
	use("ap/vim-css-color")
	-- auto close tags
	use("windwp/nvim-ts-autotag")
end)
