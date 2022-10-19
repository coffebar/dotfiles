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
	-- install without yarn or npm
	use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	})
end)
