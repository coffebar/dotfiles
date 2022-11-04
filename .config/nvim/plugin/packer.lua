vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- plugins here

	use 'ap/vim-css-color'
	-- statusline
	use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
	-- colorschemes
	use 'gruvbox-community/gruvbox'
	-- i3 config syntax highlighting
	use 'mboughaba/i3config.vim'
	-- formatter
	use 'mhartington/formatter.nvim'
	-- s-motion to search by 2 characters
	use 'justinmk/vim-sneak'
	-- fuzzy finder
	use { 'junegunn/fzf.vim', run = ":call fzf#install()" }
	-- asynchronous completion framework
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-nvim-lua'
	--use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	-- icons for "folke/trouble.nvim",
	use 'kyazdani42/nvim-web-devicons'
	-- start page
	use 'mhinz/vim-startify'
	-- search counter
	use 'google/vim-searchindex'
	-- commenter (gc)
	use 'numToStr/Comment.nvim'
	-- automatically close pairs such as (), {}, ""
	use 'cohama/lexima.vim'
	-- treesitter
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("romgrk/nvim-treesitter-context")
	-- markdown preview
	use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	})
	-- help menu
	use {
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {}
		end
	}
	-- blank char visualization
	use "lukas-reineke/indent-blankline.nvim"
	-- show debug info
	use {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup {}
		end
	}
	-- bufferline - tabs with diagnostics indicator
	use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons' }
	-- git
	use { 'lewis6991/gitsigns.nvim' }
	use { 'tpope/vim-fugitive' }
	-- snippets
	use "rafamadriz/friendly-snippets"
	-- tests
	use {
		"klen/nvim-test",
		config = function()
			require('nvim-test').setup({})
		end
	}
end)
