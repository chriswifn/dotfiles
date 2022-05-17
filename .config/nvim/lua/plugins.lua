vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	-- Packer
	use {'wbthomason/packer.nvim'}

	-- Comment
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	-- Colorscheme
	use { 'ellisonleao/gruvbox.nvim' }

	-- Telescope
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Autopairs
	use {'windwp/nvim-autopairs'}

	-- Neotree
	use {
		'kyazdani42/nvim-tree.lua',
		config = function() require'nvim-tree'.setup {} end
	}

	-- COC (completion engine)
	use {'neoclide/coc.nvim', branch='release'}

	-- vimtex
	use {'lervag/vimtex'}

	-- lualine 
	use {'nvim-lualine/lualine.nvim'}

end)
