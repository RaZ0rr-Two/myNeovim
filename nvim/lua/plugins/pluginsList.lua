-- ########################################################
-- Bootstrap ( CHeck if "packer.nvim" exists or not ) 
-- ########################################################

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- ########################################################
-- All the used plugins 
-- ########################################################

-- local use = require('packer').use
require('packer').startup({

	function(use)
		use 'wbthomason/packer.nvim' -- Package manager

		----------------------------------------------
		-- THEMES
		----------------------------------------------

		-- Colorscheme set ---------------------------
		use 'RRethy/nvim-base16'
		use 'folke/lsp-colors.nvim'

		-- Onedark -----------------------------------
		use 'navarasu/onedark.nvim'
		-- use 'joshdick/onedark.vim' 

		-- Gruvbox ------------------------------------
		-- use 'morhetz/gruvbox'

		-- --------------------------------------------
		-- General 
		-- --------------------------------------------

		-- fzf ----------------------------------------
		-- use '~/.fzf'
		-- use = { 'junegunn/fzf', run = './install --bin', }
		-- use {'junegunn/fzf.vim'}
		use { 'ibhagwan/fzf-lua',
			requires = {
			'vijaymarupudi/nvim-fzf',
			'kyazdani42/nvim-web-devicons'
			} -- optional for icons
		}
		
		-- Startup time measure -----------------------
		use 'dstein64/vim-startuptime'

		-- Undo history -------------------------------
		use 'mbbill/undotree'

		-- File Browser -------------------------------
		use 'voldikss/vim-floaterm'
		use 'is0n/fm-nvim'
		-- use {
		-- 	'kyazdani42/nvim-tree.lua',
		-- 	requires = 'kyazdani42/nvim-web-devicons',
			-- config = function() require'nvim-tree'.setup {} end
		-- }

		-- use {
		-- 	'vifm/vifm.vim',
		-- 	requires = 'is0n/fm-nvim'
		-- }
		-- Fern tree viewer
		-- use 'lambdalisue/fern.vim'
		-- use 'lambdalisue/nerdfont.vim'
		-- use 'lambdalisue/fern-renderer-nerdfont.vim'

		-- Autocompletion plugin -----------------------
		use {
			'hrsh7th/nvim-cmp',
			requires = {
				'hrsh7th/cmp-cmdline',
				'hrsh7th/cmp-nvim-lsp',
				'saadparwaiz1/cmp_luasnip',
				'hrsh7th/cmp-buffer',
				-- 'hrsh7th/cmp-emoji',
				-- 'hrsh7th/cmp-calc',
				'hrsh7th/cmp-path',
				"hrsh7th/cmp-nvim-lua"
			}
		}

		-- Snippets plugin -------------------------------
		use{
			"L3MON4D3/LuaSnip",
			requires = { "rafamadriz/friendly-snippets" },
		}

		-- Auto-pair completion --------------------------
		use 'windwp/nvim-autopairs' 

		-- Comment and Uncomment lines -------------------
		use 'b3nj5m1n/kommentary'
		use {
  		'rmagatti/auto-session',
  		config = function()
    		require('plugins/general/auto-session')
  		end
		}
		-- Better Syntax Support
		-- use 'sheerun/vim-polyglot'

		-- -----------------------------------------------
		-- UI/Look
		-- -----------------------------------------------

		-- Tab/buffers display and customize -------------
		use { 
			'akinsho/nvim-bufferline.lua', 
			requires = 'kyazdani42/nvim-web-devicons',
			-- config = function() 
				-- require("bufferline").setup{} 
			-- end
		}

		-- Show colours around hex code ------------------
		use 'norcalli/nvim-colorizer.lua'

		-- Statusline ------------------------------------
		use {
			'feline-nvim/feline.nvim',
			requires = 'kyazdani42/nvim-web-devicons',
			-- Enable for default status bar
			-- config = function() 
			--     require('feline').setup()
			-- end
		}
		-- use {
		-- 	'glepnir/galaxyline.nvim',
		-- 	branch = 'main',
		-- }

		-- highlight, navigate, and operate on sets of matching text
		use 'andymass/vim-matchup'

		-- Spell check helper plugin
		use {
			'kamykn/spelunker.vim',
			requires = {'kamykn/popup-menu.nvim'},
		}

		-- Add indentation guides even on blank lines -----
		use 'lukas-reineke/indent-blankline.nvim'

		-- Add git related info in the signs columns and popups
		use {
			'lewis6991/gitsigns.nvim', 
			requires = { 'nvim-lua/plenary.nvim' },
			config = function() 
				require('gitsigns').setup() 
			end
		}

		-- StartScreen -----------------------------------
		use {
				'goolord/alpha-nvim',
				-- config = function ()
				-- 		require'alpha'.setup(require'alpha.themes.dashboard'.opts)
				-- end
		}
		-- Startify
		-- use 'mhinz/vim-startify'

		-- Show marks and bookmarks
		use 'chentau/marks.nvim'

		-- Registers in floating window and other convenience
		use "tversteeg/registers.nvim"

		--------------------------------------------------
		-- LSP 
		--------------------------------------------------

		-- Collection of configurations for built-in LSP client
		use 'neovim/nvim-lspconfig'
		use {'stevearc/aerial.nvim'}
		-- use({
		-- 	"jose-elias-alvarez/null-ls.nvim",
			-- config = function()
			-- 	require("null-ls").setup()
			-- end,
		-- 	requires = { "nvim-lua/plenary.nvim" },
		-- })

		-- Show lightbulb for diagnostics ----------------
		use 'kosayoda/nvim-lightbulb'

		-- Signature help plug ---------------------------
		use 'ray-x/lsp_signature.nvim'

		-- Higlight occurances of word under cursor ------
		use 'RRethy/vim-illuminate'

		-- Lsp better functioning. -----------------------
		-- use  {
		-- 	'RishabhRD/nvim-lsputils',
		-- 	requires = {'RishabhRD/popfix'}
		-- }

		--------------------------------------------------
		-- Treesitter
		--------------------------------------------------

		-- Highlight, edit, and navigate code using a fast incremental parsing library
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

		-- Additional textobjects for treesitter ---------
		use {
			'nvim-treesitter/nvim-treesitter-textobjects',
			requires = {'nvim-treesitter/nvim-treesitter'}
		}

		-- Context aware commenting using treesitter
		use {
			'JoosepAlviste/nvim-ts-context-commentstring',
			requires = {'nvim-treesitter/nvim-treesitter'}
		}

		-- Folding faster --------------------------------
		use 'Konfekt/FastFold'

		if packer_bootstrap then
		  require('packer').sync()
		end

	end,

	config = {
		profile = {
			enable = true,
			threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		display = {
			open_fn = require('packer.util').float,
			-- open_fn = function()
			-- 	return require('packer.util').float({ border = 'single' })
			-- end
		}
	}

})

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost pluginsList.lua source <afile> | echom "Updating and Recompiling plugins" | PackerSync
		" autocmd BufWritePost **/pluginsList.lua lua packerSyncandSource()
    " autocmd BufWritePost **/pluginsList.lua echo "Updating plugins" | :PackerSync | source $MYVIMRC
  augroup end
]])
