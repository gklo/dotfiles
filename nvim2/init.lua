vim.g.mapleader = ' '
vim.o.hidden = true
vim.o.backup = false
vim.o.writebackup = false

vim.o.termguicolors = true

vim.o.background = "dark"
vim.o.guifont = "SFMono Nerd Font:h11"

-- vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.number = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true

-- custom completion behaviors for command line
vim.o.wildignorecase = true
vim.o.wildmode = "longest:full,full"
vim.o.wildmenu = true

vim.o.completeopt = "menu,menuone,noselect"
vim.o.cmdheight = 1

--system
vim.o.mouse = "a"
vim.o.swapfile = false
vim.o.errorbells = false

--auto reload (first line is no enough)
vim.o.autoread = true
vim.cmd("au CursorHold * checktime")

-- fix backspace
vim.o.backspace = "eol,start,indent"
vim.o.magic = true

--faster response time
vim.o.updatetime = 300
-- Don't pass messages to |ins-completion-menu|.
vim.o.shortmess = vim.o.shortmess .. "c"

-- set large redrawtime to make sure syntax highlight working all the time
vim.o.rdt = 10000

vim.o.foldnestmax = 1

vim.o.lazyredraw = true

-- remove trailing space
--autocmd BufWritePre * %s/\s\+$//e

-- show pressed key
vim.o.showcmd = true

local osname = vim.loop.os_uname().sysname
if string.find(osname, "Windows") then
  vim.o.shell = "cmd"
elseif vim.fn.executable("fish") then
  vim.o.shell = "fish"
end

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.lsp = 2

vim.o.title = true
vim.o.titlestring = "%(%{expand('%:~:.:h')}%)\\%t"

--fix newline at the end of file (causing git changes)
vim.o.fixendofline = false

--hide the tilde characters on the blank lines
--better diff looking
--[[ vim.opt.fillchars:append({ eob = " ", vert = "▏", diff = "╱" }) ]]
vim.opt.fillchars:append({ eob = " ", diff = "╱" })

-- enable replace preview
vim.o.inccommand = "split"

vim.o.wrap = true
-- disable terminal numbers
vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber')

-- config lsp diagnostic
vim.diagnostic.config({
  virtual_text = {
    -- Do not underline text when severity is low (INFO or HINT).
    severity = { min = vim.diagnostic.severity.WARN },
  },
})

-- autocomplete
vim.o.pumheight = 10


-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
  end,
})

-- search
vim.o.incsearch = false

-- 0.8 features
vim.o.winbar = '%f'
vim.o.laststatus = 3


-- commands
vim.api.nvim_create_user_command('Reload', function()
  vim.cmd('source ' .. vim.fn.expand('$MYVIMRC'))
  vim.cmd('PackerCompile')
end, {})

-- packer
require('packer').startup(function(use)
  use {
    'wbthomason/packer.nvim',
    -- fundamental
    'tpope/vim-repeat',
    'machakann/vim-sandwich',
    {
      'notjedi/nvim-rooter.lua',
      config = function() require 'nvim-rooter'.setup({
        rooter_patterns = { '.git', '.hg', '.svn', 'init.lua' },
        trigger_patterns = { '*' },
      })
    end
  },

  -- colorscheme
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd [[colorscheme tokyonight-moon]]
    end
  },

  { 'tamton-aquib/staline.nvim', config = function()
    require "staline".setup {
      sections = {
        left = { '  ', 'mode', 'file_name' },
        mid = {},
        right = { 'branch', 'line_column' }
      },
      mode_colors = {
        i = "#d4be98",
        n = "#84a598",
        c = "#8fbf7f",
        v = "#fc802d",
      },
      defaults = {
        true_colors = true,
        line_column = "%y [%l/%L] :%c ",
        branch_symbol = " "
      }
    }
  end },
  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              preview_height = 0.6,
              preview_cutoff = 1
            }
          },
        },
      })
    end
  },
  -- treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
    require 'nvim-treesitter.configs'.setup {
      auto_install = true,
      highlight = {
        enabled = true
      }
    }
  end },
  { 'JoosepAlviste/nvim-ts-context-commentstring', requires = { 'tpope/vim-commentary' }, config = function()
    require 'nvim-treesitter.configs'.setup {
      context_commentstring = {
        enable = true
      }
    }
  end },

  -- lsp
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim", requires = { 'williamboman/mason.nvim' }, config = function()
    require('mason').setup() 
    local lspconfig = require 'lspconfig'
    require("mason-lspconfig").setup({
      ensure_installed = { 'tsserver', 'tailwindcss', 'volar', 'sqlls', 'pyright', 'intelephense', 'marksman', 'eslint',
      'cssls', 'html', 'yamlls', 'jsonls', 'quick_lint_js' },
      automatic_installation = true
    })

    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end

      local opts = { noremap = true, silent = true }

      if client.name == 'eslint' then
        vim.cmd('autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js,*.json EslintFixAll')
      end

      buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
      buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
      buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      buf_set_keymap("n", "gh", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
      buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

      if client.server_capabilities.documenthighlightprovider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("cursorhold", {
          callback = vim.lsp.buf.document_highlight,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "document highlight",
        })
        vim.api.nvim_create_autocmd("cursormoved", {
          callback = vim.lsp.buf.clear_references,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "clear all the references",
        })
      end
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require("mason-lspconfig").setup_handlers({
      function(server_name) -- default handler (optional)
        local opts = {
          on_attach = on_attach,
          capabilities = capabilities,
          single_file_support = true,
          -- flags = {
          --   debounce_text_changes = 2000
          -- }
        }

        if server_name == 'tsserver' then
          opts.settings = {
            implicitProjectConfiguration = { 
              checkJs = true
            },
          }
        end
        if server_name == 'tsserver' or server_name == 'tailwindcss' then
          opts.root_dir = function(fname)
            return lspconfig.util.root_pattern(".git", "package.json", "tsconfig.json", "jsconfig.json")(fname) or
            vim.fn.getcwd()
          end
        elseif server_name == 'eslint' then
        elseif server_name == "sumneko_lua" then
          local runtime_path = vim.split(package.path, ";")
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")
          opts.settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          }
        end

        require("lspconfig")[server_name].setup(opts)
      end
    })


    -- disable insert update
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,{ update_in_insert = false })
  end },
  "neovim/nvim-lspconfig",
  "glepnir/lspsaga.nvim",
  -- nvim cmp
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  { 'hrsh7th/nvim-cmp', config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    if cmp == nil then return end

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            --[[ cmp.select_next_item() ]]
            cmp.confirm({ select = true })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "copilot", group_index = 1 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end },
  { 'L3MON4D3/LuaSnip', requires = { 'rafamadriz/friendly-snippets' }, config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end },
  'saadparwaiz1/cmp_luasnip',
  -- 'rafamadriz/friendly-snippets',
  'johngrib/vim-game-code-break',
  { 'yamatsum/nvim-cursorline', config = function()
    require('nvim-cursorline').setup {
      cursorline = {
        timeout = 300,
      },
    }
  end },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },
  {
    'windwp/nvim-ts-autotag',
    config = function () require('nvim-ts-autotag').setup {} end
  },
  { 'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup {}
    end 
  },
  {
    'maxmellon/vim-jsx-pretty',
  },
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {}
    end
  },
  {
    'shellRaining/hlchunk.nvim',
    config = function() 
      require('hlchunk').setup {}
    end
  },
  {
    "https://git.sr.ht/~nedia/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end
  },
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.keymap.set("i", "<C-c>", "copilot#Accept('')", {expr=true, silent=true})
  --   end
  -- },
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }
}
end)

-- commands
require('mappings')
