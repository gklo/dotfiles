-- Global mettings
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

-- Share registers (and other ShaDa data) between Neovim instances
vim.api.nvim_create_autocmd({ "TextYankPost", "CursorHold", "FocusGained", "FocusLost" }, {
  group = vim.api.nvim_create_augroup("ShadaSync", { clear = true }),
  callback = function()
    if vim.fn.exists(":wshada") == 2 then
      pcall(vim.cmd, "wshada")
      pcall(vim.cmd, "rshada")
    end
  end,
})

-- smarter dd, if the line is empty, delete to black hole, otherwise delete normally, respect count
vim.keymap.set('n', 'dd', function()
  local line = vim.api.nvim_get_current_line()
  if line:match('^%s*$') then
    -- Delete to black hole, respect count
    local count = vim.v.count1
    vim.cmd('normal! ' .. count .. '"_dd')
  else
    vim.cmd('normal! ' .. vim.v.count1 .. 'dd')
  end
end)

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

-- make sure using the latest node version instead of the workspace version
if vim.fn.executable("fnm") == 1 then
  vim.env.PATH = vim.fn.system('fnm use 24 > /dev/null && echo $PATH')
end

-- LSP

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      },
      diagnostics = {
        globals = { "vim", "require", "Snacks" }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true)
      }
    }
  }
})

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
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Enable or disable italics for comments, functions, etc.
        italics = true,

        -- Optional: If you want to disable italics specifically for comments
        disable_italic_comments = false,

        -- Other configurations...
        background = "medium",
        transparent_background_level = 0,
      })
      vim.cmd("colorscheme everforest")
    end,
  },
  -- plugins
  "tpope/vim-repeat",
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
    lazy = false,
    build = ":TSUpdate",
    opts = {}
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      auto_install = true,
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },

    },
  },
  -- lsp
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  "maxmellon/vim-jsx-pretty",
  {
    "NMAC427/guess-indent.nvim",
    opts = {}
  },
  {
    "rmagatti/auto-session",
    dependencies = { "nvim-tree/nvim-tree.lua" },
    config = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

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
  -- pickers, file explorer, lazugit ...etc.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      rename = { enabled = true },
      -- indent = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = "vertical"
        },
        layouts = {
          vertical = {
            layout = {
              width = 0.8
            }
          }
        },
        sources = {
          grep = {
            exclude = {
              "**/pnpm-lock.yaml", -- covers pnpm-lock.yaml
              "**/node_modules/**",
              "**/.git/**",
              -- add any other patterns you want, e.g.:
              "**/dist/**",
              "**/build/**",
              "**/.yarn/**",
              "**/.pnpm-store/**",
              "**/*.gen.ts"
            },
          }
        }
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
      input = { enabled = true }
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
    opts = {
      debounce_delay = 3000,
    },
  },
  -- proper tag selection for jsx
  { 'nvim-mini/mini.ai',    version = '*', opts = {} },
  { 'nvim-mini/mini.icons', version = '*', opts = {} },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = "everforest"
    }
  },
  {
    'saghen/blink.pairs',
    build = function() require('blink.pairs').build():pwait(60000) end,
    version = '*', -- (recommended) only required with prebuilt binaries
    dependencies = 'saghen/blink.download',
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
        pairs = {},
      },
      highlights = {
        enabled = false,
        cmdline = false,
        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = 'BlinkPairsMatchParen',
          priority = 250,
        },
      },
      debug = false,
    }
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      -- 'zbirenbaum/copilot.lua',
      'onsails/lspkind.nvim'
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'super-tab',
        -- ['<Tab>'] = {
        --   function(cmp)
        --     local copilot = require('copilot.suggestion')
        --
        --     if cmp.snippet_active() then
        --       return cmp.accept()
        --     elseif copilot.is_visible() then
        --       return copilot.accept()
        --     else
        --       return cmp.select_and_accept()
        --     end
        --   end,
        --   'snippet_forward',
        --   'fallback'
        -- },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500
        },

        accept = { auto_brackets = { enabled = false }, },
      },

      signature = {
        enabled = true
      }
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      local blink = require('blink.cmp')
      local capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
          }
        }
      }

      capabilities = blink.get_lsp_capabilities(capabilities)
      vim.lsp.config('*', {
        capabilities = capabilities
      })

      -- hide copilot suggestion on cmp
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'BlinkCmpMenuOpen',
      --   callback = function()
      --     require("copilot.suggestion").dismiss()
      --     vim.b.copilot_suggestion_hidden = true
      --   end,
      -- })
      --
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'BlinkCmpMenuClose',
      --   callback = function()
      --     vim.b.copilot_suggestion_hidden = false
      --   end,
      -- })
      blink.setup(opts)
    end
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10, -- Low priority to catch other plugins' keybindings
    config = function()
      require("tiny-glimmer").setup({
        overwrite = {
          yank = {
            default_animation = "fade"
          },
          undo = {
            enabled = true,
            settings = {
              max_duration = 1000,
              min_duration = 1000
            }
          },
          redo = {
            enabled = true,
            settings = {
              max_duration = 1000,
              min_duration = 1000
            }
          }
        },

        animations = {
          fade = {
            max_duration = 800, -- Maximum animation duration in ms
            min_duration = 600,
          },
          reverse_fade = {
            max_duration = 760,
            min_duration = 600,
          }
        }
      })
    end,
  },
  {
    "josstei/whisk.nvim",
    event = "VeryLazy",
    config = function()
      require("whisk").setup()
    end,
  },
  {
    'neoclide/vim-jsx-improve',
  },
  {
    "kylechui/nvim-surround",
    version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      -- disabled all default mappings
      vim.g.nvim_surround_no_mappings = true
      -- See `:h nvim-surround.keymaps`
      vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", {
        desc = "Add a surrounding pair around a motion (normal mode)",
      })
      vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", {
        desc = "Delete a surrounding pair",
      })
      vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", {
        desc = "Change a surrounding pair",
      })
      vim.keymap.set("x", "sa", "<Plug>(nvim-surround-visual)", { desc = "Add surrounding to selection" })

      require("nvim-surround").setup()
    end
  },
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    -- for nixos:
    -- build = "nix run .#release",
    opts = {
      layout = {
        prompt_position = "top",
        preview_position = "bottom"
      }
    },
    lazy = false, -- the plugin lazy-initialises itself
    keys = {
      { "<space>f", function() require('fff').find_files() end, desc = 'FFFind files' },
      { "<space>/", function() require('fff').live_grep() end,  desc = 'LiFFFe grep' },
    },
  }
})

-- commands
require("mappings")

-- override
-- vim.cmd [[colorscheme catppuccin-macchiato]]
vim.cmd [[highlight WinSeparator guifg=DarkGray]]

local function set_diagnostic_italic()
  local groups = {
    "DiagnosticError",
    "DiagnosticWarn",
    "DiagnosticInfo",
    "DiagnosticHint",
    "DiagnosticOk",
    "DiagnosticVirtualTextError",
    "DiagnosticVirtualTextWarn",
    "DiagnosticVirtualTextInfo",
    "DiagnosticVirtualTextHint",
    "DiagnosticVirtualTextOk",
    "DiagnosticFloatingError",
    "DiagnosticFloatingWarn",
    "DiagnosticFloatingInfo",
    "DiagnosticFloatingHint",
    "DiagnosticFloatingOk",
  }

  for _, group in ipairs(groups) do
    -- Get the resolved highlight (follows links)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })

    if hl and (hl.fg or hl.bg or hl.sp) then
      -- Keep existing colors, force italic
      vim.api.nvim_set_hl(0, group, {
        fg = hl.fg,
        bg = hl.bg,
        sp = hl.sp,
        italic = true,
        bold = hl.bold,
        underline = hl.underline,
        undercurl = hl.undercurl,
        strikethrough = hl.strikethrough,
      })
    else
      -- Fallback: just add italic if no color info
      vim.api.nvim_set_hl(0, group, { italic = true, default = true })
    end
  end
end

-- Run after colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- small delay so the colorscheme finishes setting highlights
    vim.defer_fn(set_diagnostic_italic, 10)
  end,
})

-- Apply now
set_diagnostic_italic()
