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
  {
    "folke/tokyonight.nvim",
    opts = {}
  },
  {
    "tamton-aquib/staline.nvim",
    config = function()
      require("staline").setup({
        sections = {
          left = { "cwd", "branch" },
          mid = {},
          right = { "line_column" }
        },
        mode_colors = {
          i = "#d4be98",
          n = "#84a598",
          c = "#8fbf7f",
          v = "#fc802d"
        },
        defaults = {
          true_colors = true,
          line_column = "%l:%c %y"
          -- branch_symbol = " "
        }
      })
    end
  }, -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("telescope").setup({
        pickers = {
          colorscheme = {
            enable_preview = true
          }
        },
        defaults = {
          file_ignore_patterns = { ".git", "node_modules", "vendor" },
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              preview_height = 0.6,
              preview_cutoff = 1
            }
          }
        }
      })
    end
  },
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate'
  },
  {
    "shushtain/nvim-treesitter-incremental-selection",
    config = function()
      local tsis = require("nvim-treesitter-incremental-selection")

      tsis.setup()
      vim.keymap.set("n", "v", tsis.init_selection)
      vim.keymap.set("v", "v", tsis.increment_node)
      vim.keymap.set("v", "V", tsis.decrement_node)
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
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          "accept",
          function()
            if require("copilot.suggestion").is_visible() then
              return require("copilot.suggestion").accept()
            end
          end,
          "fallback",
        },
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      completion = {
        documentation = { auto_show = true },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

    },
    opts_extend = { "sources.default" }
  },
  {
    "yamatsum/nvim-cursorline",
    config = function()
      require("nvim-cursorline").setup({
        cursorline = {
          timeout = 300
        }
      })
    end
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {
      opts = {
        enable_rename = false,
        enable_close_on_slash = false
      }
    }
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = math.floor(screen_w * 0.8)
            local window_h = math.floor(screen_h * 0.8)
            return {
              title = " NvimTree ",
              title_pos = "center",
              border = "rounded",
              relative = "editor",
              row = (screen_h - window_h) * 0.5,
              col = (screen_w - window_w) * 0.5,
              width = window_w,
              height = window_h
            }
          end
        }
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        -- set no horizontal scroll
        vim.cmd([[set mousescroll=hor:0]])
        -- vim.api.nvim_exec("set mousescroll=hor:0", true)
      end,
      hijack_cursor = true, -- keep cursor on the first letter
      renderer = {
        indent_width = 2,
        icons = {
          git_placement = "signcolumn",
          show = {
            folder_arrow = false
          },
          glyphs = {
            folder = {
              default = "",
              open = "",
              symlink = ""
            }
          }
        },
        indent_markers = {
          enable = true
        }
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true
      },
      filters = {
        custom = { "^.git$", "^.github$" }
      },
      actions = {
        change_dir = {
          enable = false,
          restrict_above_cwd = true
        }
      }
    }
  },
  "maxmellon/vim-jsx-pretty",
  {
    "NMAC427/guess-indent.nvim",
    opts = {}
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({
        blank = {
          enable = false
        },
        indent = {
          enable = false
        }
      })
    end
  },
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    opts = {
      suggestion = {
        auto_trigger = true
      }
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
    "rebelot/kanagawa.nvim",
    opts = {}
  },
  {
    "pocco81/auto-save.nvim",
    opts = {
      -- debounce_delay = 3000,
    }
  },
  {
    "lambdalisue/suda.vim",
    config = function()
      vim.g.suda_smart_edit = true
    end
  }, -- Lua
  {
    "0oAstro/dim.lua",
    dependencies = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    opts = {}
  },
  { -- peek definition
    "dnlhc/glance.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration
    }
  },
  { -- keep cursor in place after > or =
    "gbprod/stay-in-place.nvim",
    opts = {}
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- require("nordic").load()
    end
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
    "EdenEast/nightfox.nvim",
    lazy = false,
    config = function()
      -- vim.cmd [[colorscheme duskfox]]
    end
  },
  {
    'stevearc/conform.nvim',
    opts = {
      config = function()
        require('conform').setup({
          formatters_by_ft = {
            lua = { "stylua" },
            javascriptreact = { "prettierd", "prettier" },
            javascript = { "prettierd", "prettier" }
          }
        })
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end
    }
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" -- optional dependency
    },
    opts = {
      -- configurations go here
    }
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-tree.lua" },
    opts = {}
  },
  {
    "fcancelinha/nordern.nvim",
    branch = "master",
    priority = 1000
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
  }
})

-- commands
require("mappings")

-- override
vim.cmd [[colorscheme nordfox]]
vim.cmd [[highlight WinSeparator guifg=darkgray1]]

vim.cmd [[autocmd VimEnter * silent! !prettierd restart]]

-- transparent background
vim.cmd [[
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
highlight SignColumn ctermbg=none guibg=none
]]
