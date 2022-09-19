-- Syntax hightlighting
--Plug 'sheerun/vim-polyglot';
require "paq" {
  -- basics
  "nvim-lua/plenary.nvim",
  "tpope/vim-repeat",
  -- treesitter
  "nvim-treesitter/nvim-treesitter",
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   run = function()
  --     vim.cmd "TSUpdate"
  --   end
  -- },
  "JoosepAlviste/nvim-ts-context-commentstring",
  "romgrk/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-refactor",
  -- specfic syntax
  "dag/vim-fish",
  "jlcrochet/vim-razor",
  "kchmck/vim-coffee-script",
  "alampros/vim-styled-jsx",
  { "styled-components/vim-styled-components", branch = "main" },
  -- telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-live-grep-raw.nvim",
  -- productivity
  "numToStr/Comment.nvim",
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",
  "SmiteshP/nvim-gps",
  "phaazon/hop.nvim",
  "tpope/vim-fugitive",
  -- "tpope/vim-surround",
  "machakann/vim-sandwich",
  "machakann/vim-highlightedyank",
  "akinsho/toggleterm.nvim",
  "norcalli/nvim-colorizer.lua",
  "RRethy/vim-illuminate",
  "kevinhwang91/nvim-bqf",
  "kyazdani42/nvim-tree.lua",
  -- LSP
  "neovim/nvim-lspconfig",
  --[[ "williamboman/nvim-lsp-installer", ]]
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "ray-x/lsp_signature.nvim",
  -- completion with LSP
  -- "hrsh7th/vim-vsnip",
  -- "hrsh7th/vim-vsnip-integ",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",

  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  -- fancy line
  "nvim-lualine/lualine.nvim",
  -- theme
  --Plug 'rakr/vim-one' " Doesn't support treesitter/cmp
  -- Plug 'dracula/vim', { 'as': 'dracula' }
  'shaunsingh/nord.nvim',
  "kyazdani42/nvim-web-devicons",
  "ryanoasis/vim-devicons",
  -- others
  "mhartington/formatter.nvim",
  -- "airblade/vim-rooter",
  "ianding1/leetcode.vim",
  -- for nvim-qt to work with ginit commands (remotely)
  "equalsraf/neovim-gui-shim",
  "dstein64/vim-startuptime",
  -- optimized cursorline
  "yamatsum/nvim-cursorline",
  "ahmedkhalf/project.nvim",
  "lukas-reineke/indent-blankline.nvim",
  'f-person/git-blame.nvim',
  'chaoren/vim-wordmotion',
  'sindrets/diffview.nvim',
  'lewis6991/gitsigns.nvim',
  'onsails/lspkind.nvim',
  'petertriho/nvim-scrollbar',
  'folke/tokyonight.nvim',
  'tpope/vim-sleuth',
  'navarasu/onedark.nvim',
  'narutoxy/dim.lua',
  'Mofiqul/dracula.nvim',
  --[[ 'sunjon/shade.nvim', ]]
  'projekt0n/github-nvim-theme',
  --[[ 'rmagatti/goto-preview', ]]
  'glepnir/lspsaga.nvim',
  'stevearc/dressing.nvim',
  'kevinhwang91/promise-async',
  'kevinhwang91/nvim-ufo'
}
