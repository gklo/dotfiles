-- theme
require("github-theme").setup({
  theme_style = "dimmed",
})
--[[ vim.cmd('colorscheme github_dark_default') ]]
vim.cmd("highlight signcolumn guibg=none ctermbg=none")

-- formatter
require("formatter").setup(
  {
    filetype = {
      lua = {
        -- luafmt
        function()
          return {
            exe = "/usr/local/bin/luafmt",
            args = { "--indent-count", 2, "--stdin" },
            stdin = true
          }
        end
      }
    }
  }
)

-- toggleterm
require "toggleterm".setup {
  direction = "horizontal"
}

-- telescope
local telescope = require("telescope")
telescope.load_extension "file_browser"
telescope.load_extension "projects"
telescope.setup {
  defaults = require('telescope.themes').get_ivy {
  },
}

-- symbols
vim.g.symbols_outline = {
  width = 80
}

-- nvim tree
require "nvim-tree".setup {
  disable_netrw       = false,
  hijack_netrw        = false,
  update_cwd          = false,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {}
  },
  view                = {
    width = 40
  }
}

-- yank highlight
vim.g.highlightedyank_highlight_duration = 200

-- leetcode
vim.g.leetcode_browser = "firefox"
vim.g.leetcode_solution_filetype = "javascript"

-- nvim-cmpsetup
local cmp = require 'cmp'
local luasnip = require("luasnip")
local lspkind = require'lspkind'
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-b>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-e>'] = cmp.mapping.abort(),
    ['<cr>'] = cmp.mapping.confirm({ select = false }), -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
     ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
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
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format()
  }
})

-- set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- you can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


-- lspconfig.
local lspconfig = require "lspconfig"
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { 'tsserver', 'tailwindcss', 'volar', 'sqlls', 'pyright', 'intelephense', 'marksman', 'eslint',
    'cssls', 'html', 'yamlls', 'jsonls', 'quick_lint_js', 'sumneko_lua' },
  automatic_installation = true
})

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

  -- illuminate integrated with lsp
  require 'illuminate'.on_attach(client)

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

require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities
    }

    if server_name == 'tsserver' or server_name == 'tailwindcss' then
      opts.root_dir = function(fname)
        return lspconfig.util.root_pattern(".git", "package.json", "tsconfig.json", "jsconfig.json")(fname) or
            vim.fn.getcwd()
      end
      opts.single_file_support = true
    elseif server_name == 'eslint' then
      opts.single_file_support = true
    elseif server_name == "sumneko_lua" then
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      opts.settings = {
        lua = {
          runtime = {
            -- tell the language server which version of lua you're using (most likely luajit in the case of neovim)
            version = "luajit",
            -- setup your lua path
            path = runtime_path
          },
          diagnostics = {
            -- get the language server to recognize the `vim` global
            globals = { "vim" }
          },
          workspace = {
            -- make the server aware of neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true)
          },
          -- do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false
          }
        }
      }
    end

    require("lspconfig")[server_name].setup(opts)
  end
})

--[[ require "lsp_signature".setup { ]]
--[[   floating_window = false ]]
--[[ } ]]

-- treesitter
require "nvim-treesitter.configs".setup {
  ensure_installed = { "html", "css", "scss", "vim", "lua", "javascript", "typescript", "tsx", "json", "python", "vue",
    'rust', 'bash', 'elm', 'elixir' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<M-v>",
      node_incremental = "<M-v>",
      node_decremental = "<M-c>",
      --[[ scope_incremental = "<tab>" ]]
    }
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    -- plugin
    enable = true,
    enable_autocmd = false
  },
  autotag = {
    -- plugin
    enable = true
  },
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grn"
      }
    }
  }
}
require "treesitter-context".setup {}

-- comment
require("comment").setup {
  pre_hook = function(ctx)
    local u = require "comment.utils"

    local location = nil
    if ctx.ctype == u.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == u.cmotion.v or ctx.cmotion == u.cmotion.v then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == u.ctype.line and "__default" or "__multiline",
      location = location
    }
  end
}

-- autopairs
require("nvim-autopairs").setup {}
-- if you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
-- add a lisp filetype (wrap my-function), fyi: hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
-- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

-- nvim-gps
local gps = require "nvim-gps"
gps.setup()

-- lualine
local function tabstopstatus()
  return " " .. vim.api.nvim_get_option("tabstop")
end

require("lualine").setup {
  options = {
    -- theme = 'palenight',
    theme = "auto",
    component_separators = "|",
    section_separators = { left = "", right = "" }
  },
  sections = {
    lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2, fmt = function(str) return str:sub(1, 1) .. ' ' end }
    },
    lualine_b = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = "*", -- text to show when the file is modified.
          readonly = " ", -- text to show when the file is non-modifiable or readonly.
          unnamed = "[untitled]" -- text to show for unnamed buffers.
        }
      },
      "branch",
      "diff"
    },
    lualine_c = { { gps.get_location, cond = gps.is_available } },
    lualine_x = {},
    lualine_y = { "filetype", "fileformat", tabstopstatus, "diagnostics" },
    lualine_z = {
      { "progress", separator = { right = "" }, left_padding = 2 }
    }
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { "toggleterm", "fugitive", "nvim-tree" }
}

-- colorizer
require "colorizer".setup {
  css = {
    css_fn = true
  }
}

-- hop
require "hop".setup()

-- projects
require("project_nvim").setup {
}

-- indent blank line
require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
  show_current_context = true,
  show_current_context_start = true,
}

-- gitsign
require('gitsigns').setup()

-- scrollbar
require("scrollbar").setup()

-- dim unused
--[[ require('dim').setup({}) ]]

-- dim window
--[[ require'shade'.setup({ ]]
--[[   overlay_opacity = 50, ]]
--[[   opacity_step = 1, ]]
--[[ }) ]]

-- preview
--[[ require('goto-preview').setup { ]]
--[[   default_mappings = true; ]]
--[[ } ]]

-- lspsaga
require("lspsaga").init_lsp_saga({
  rename_in_select = false,
  finder_action_keys = {
    open = "<cr>",
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = "q",
  },
  code_action_keys = {
    quit = "q",
    exec = "<cr>",
  },
  definition_action_keys = {
    edit = '<cr>',
    vsplit = '<c-v>',
    split = '<c-x>',
    tabe = '<c-t>',
    quit = 'q',
  },
})

-- ufo
--[[ require("ufo").setup { ]]
--[[   provider_selector = function(bufnr, filetype) ]]
--[[     return { "treesitter", "indent" } ]]
--[[   end, ]]
--[[ } ]]

-- fidget
require'fidget'.setup{}

-- dim other functions
require('twilight').setup{}
