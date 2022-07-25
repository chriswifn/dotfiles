local status_ok, packer = pcall(require, 'packer')
if not status_ok then
	return
end

return packer.startup(function(use)

	-- packer: package manager
	use 'wbthomason/packer.nvim'

	-- autopair: no one wants to type closing brackets
	use {
		'windwp/nvim-autopairs',
    event = "BufWinEnter",
		config = function()
			require('nvim-autopairs').setup()
		end
	}

  -- impatient: better startup time
  use 'lewis6991/impatient.nvim'

  -- colorizer: for coloring hex codes
  use {
    'norcalli/nvim-colorizer.lua',
    event = "BufWinEnter",
    config = function()
      require('colorizer').setup()
    end
  }

	-- comment: commenting manually is too inefficient
	use {
		'numToStr/Comment.nvim',
    event = "BufWinEnter",
		config = function()
			require('Comment').setup()
		end
	}

	-- treesitter: syntax highlighting and some other cool stuff
	use 'nvim-treesitter/nvim-treesitter'

	-- lsp: very useful
	use 'neovim/nvim-lspconfig'

  -- autotag: mainly for html because closing or updating tags in html is annoying
  use {
    'windwp/nvim-ts-autotag',
    require('nvim-ts-autotag').setup();
  }

	-- autocomplete: very important
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'L3MON4D3/LuaSnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',
			'saadparwaiz1/cmp_luasnip',
		},
	}

  -- fzf: the best fuzzy finder there ever was and will ever be
  -- use 'ibhagwan/fzf-lua'

  -- gruvbox: chad colorscheme, stop using all these other virgin colorschemes
  use 'ellisonleao/gruvbox.nvim'

  -- statusline
  use 'tjdevries/express_line.nvim'
  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-file-browser.nvim',
    }
  }

	if packer_bootstrap then
		require('packer').sync()
	end
end)
