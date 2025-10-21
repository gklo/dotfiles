-- Global settings
vim.g.mapleader = " "

-- Backup and file handling
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.opt.fixeol = false

-- UI and appearance
vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.signcolumn = "yes"
vim.o.laststatus = 3
vim.o.showcmd = true
vim.o.title = true
vim.o.titlestring = "%(%{expand('%:~:.:h')}%)\\%t"
vim.opt.fillchars:append({
  eob = " ",
  diff = "╱"
})
-- Editing and indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.backspace = "eol,start,indent"
vim.o.wrap = true

-- Search and completion
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true
vim.o.incsearch = false
vim.o.wildignorecase = true
vim.o.wildmode = "longest:full,full"
vim.o.wildmenu = true
vim.o.completeopt = "menu,menuone,noselect"
vim.o.cmdheight = 1
vim.o.pumheight = 10
vim.o.inccommand = "split"

-- Mouse
vim.o.mouse = "a"
vim.o.errorbells = false

-- Performance and behavior
vim.o.autoread = true
vim.o.updatetime = 300
vim.opt.shortmess:append("c")
vim.o.redrawtime = 10000
vim.o.foldnestmax = 1

-- Window and splits
vim.o.splitbelow = true
vim.o.splitright = true

-- auto reload (first line is no enough)
vim.cmd("au CursorHold * checktime")

-- disable terminal numbers
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")

vim.cmd("autocmd BufNewFile,BufRead *.js set filetype=javascriptreact")

-- config lsp diagnostic
vim.diagnostic.config({
  underline = false,
  signs = false,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    severity = {
      min = vim.diagnostic.severity.WARN
    }
  }
})

-- yank highlight and preserve cursor position
local augroups = {}
augroups.yankpost = {
  save_cursor_position = {
    event = { "VimEnter", "CursorMoved" },
    pattern = "*",
    callback = function()
      cursor_pos = vim.fn.getpos(".")
    end
  },

  highlight_yank = {
    event = "TextYankPost",
    pattern = "*",
    callback = function()
      vim.hl.on_yank({
        higroup = "IncSearch",
        timeout = 200,
        on_visual = true
      })
    end
  },

  yank_restore_cursor = {
    event = "TextYankPost",
    pattern = "*",
    callback = function()
      local cursor_pos = vim.fn.getpos(".")
      if vim.v.event.operator == "y" then
        vim.fn.setpos(".", cursor_pos)
      end
    end
  }
}
for group, commands in pairs(augroups) do
  local augroup = vim.api.nvim_create_augroup("AU_" .. group, {
    clear = true
  })

  for _, opts in pairs(commands) do
    local event = opts.event
    opts.event = nil
    opts.group = augroup
    vim.api.nvim_create_autocmd(event, opts)
  end
end

-- make sure using the latest node version instead of the workspace version
if vim.fn.executable("fnm") == 1 then
  vim.env.PATH = vim.fn.system('fnm use 22 && echo $PATH')
end

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system(
    { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
      lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- color schemes
  "EdenEast/nightfox.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- plugins
  "tpope/vim-repeat",
  "machakann/vim-sandwich",
  {
    "notjedi/nvim-rooter.lua",
    config = function()
      require("nvim-rooter").setup({
        rooter_patterns = { ".git", ".hg", ".svn", "init.lua" },
        trigger_patterns = { "*" }
      })
    end
  },
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        auto_install = true,
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          },
        },
      }
    end
  },
  -- lsp
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local on_attach = function(client, bufnr)
        -- highlight references
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = true
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight"
          })
          vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "document highlight"
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "clear all the references"
          })
        end
      end

      local servers = { "tailwindcss", "sqlls", "pyright", "marksman", "eslint", "cssls", "html", "yamlls", "jsonls",
        "lua_ls" }


      local capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
          }
        }
      }

      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      for _, server in ipairs(servers) do
        local opts = {
          capabilities = capabilities,
          on_attach = on_attach,
          single_file_support = true
        }

        if server == "lua_ls" then
          opts.settings = {
            Lua = {
              runtime = {
                version = "LuaJIT"
              },
              diagnostics = {
                globals = { "vim", "require" }
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
              }
            }
          }
        end

        vim.lsp.config(server, opts)
      end

      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_enable = true,
        ensure_installed = { "tailwindcss", "sqlls", "pyright", "marksman", "eslint", "cssls", "html", "yamlls", "jsonls" }
      })
    end
  },
  "neovim/nvim-lspconfig",
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ["<Tab>"] = {
          "snippet_forward",
          "select_next",
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          function()
            if require("copilot.suggestion").is_visible() then
              return require("copilot.suggestion").accept()
            end
          end,
          "fallback",
        },
        ["("] = {
          function(cmp)
            cmp.accept({
              callback = function()
                vim.api.nvim_feedkeys("(", "n", false)
              end,
            })
          end,

          "fallback",
        },
        ["["] = {
          function(cmp)
            cmp.accept({
              callback = function()
                vim.api.nvim_feedkeys("[", "n", false)
              end,
            })
          end,

          "fallback",
        },

        ["."] = {
          function(cmp)
            cmp.accept({
              callback = function()
                vim.api.nvim_feedkeys(".", "n", false)
              end,
            })
          end,
          "fallback",
        },
        ["<Space>"] = {
          function(cmp)
            cmp.accept({
              callback = function()
                vim.api.nvim_feedkeys(" ", "n", false)
              end,
            })
          end,
          "fallback",
        },
        ["<CR>"] = {
          "accept",
          "fallback"
        }
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        accept        = { auto_brackets = { enabled = false }, },
        documentation = { auto_show = true },
        ghost_text    = {
          enabled = true,
          show_without_selection = true,
          show_with_menu = true,
          show_without_menu = true,
        },
        list          = {
          selection = {
            preselect = false,
            auto_insert = true,
          }
        }
      },
      menu = {
        auto_show_delay_ms = 500,
      },
      sources = {
        -- default = { 'lsp', 'path', 'snippets', 'buffer' },
        min_keyword_length = 2
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" }
  },
  "maxmellon/vim-jsx-pretty",
  {
    "NMAC427/guess-indent.nvim",
    opts = {}
  },
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    opts = {
      suggestion = {
        auto_trigger = true
      },
    }
  },
  {
    "rmagatti/auto-session",
    dependencies = { "nvim-tree/nvim-tree.lua" },
    config = function()
      local api = require("nvim-tree.api")
      local function close_nvim_tree()
        api.tree.close()
      end
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        bypass_session_save_file_types = { "NvimTree" },
        -- fix nvim-tree
        pre_save_cmds = { close_nvim_tree }
      })
    end
  },
  {
    "lambdalisue/suda.vim",
    config = function()
      vim.g.suda_smart_edit = true
    end
  }, -- Lua
  {  -- keep cursor in place after > or =
    "gbprod/stay-in-place.nvim",
    opts = {}
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      messages = {
        view_error = "mini",
        view_warn = "mini",
        view = "mini"
      },
      notify = {
        view = "mini"
      }
    },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup()
      -- native comment
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring() or
            get_option(filetype, option)
      end
    end
  },
  -- copilot nes completion
  {
    "folke/sidekick.nvim",
    opts = {},
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },
  -- pickers, file explorer, lazugit ...etc.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      -- indent = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true }
    },
    keys = {
      -- files
      { "<leader>f",        function() Snacks.picker.files() end,                 desc = "Find Files" },
      { "<leader><leader>", function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<leader>/",        function() Snacks.picker.grep() end,                  desc = "Grep" },
      { "<leader>q",        function() Snacks.picker.qflist() end,                desc = "Quick Fix" },
      { "<C-e>",            function() Snacks.explorer() end,                     desc = "Explorer" },
      -- LSP
      { "gd",               function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
      { "gD",               function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
      { "gr",               function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
      { "gI",               function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      { "gy",               function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
      { "<leader>s",        function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
      { "<leader>S",        function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- misc
      { "<leader>gs",       function() Snacks.picker.git_status() end,            desc = "Git Status" },
      { "<leader>C",        function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
      { "<leader>l",        function() Snacks.lazygit() end,                      desc = "lazygit" }
    }
  },
  -- auto save
  {
    "pocco81/auto-save.nvim",
    opts = {}
  },
  -- proper tag selection for jsx
  {
    'mawkler/jsx-element.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ft = { 'typescriptreact', 'javascriptreact', 'javascript' },
    opts = {},
  }
})

-- commands
require("mappings")

-- override
vim.cmd [[colorscheme catppuccin-mocha]]
vim.cmd [[highlight WinSeparator guifg=darkgray1]]

vim.cmd [[autocmd VimEnter * silent! !prettierd restart]]

-- hide copilot suggestion on cmp
vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
