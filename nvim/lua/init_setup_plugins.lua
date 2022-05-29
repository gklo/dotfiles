-- theme
vim.cmd("let g:nvcode_termcolors=256")
vim.cmd("colorscheme onedark")
vim.cmd("highlight SignColumn guibg=NONE ctermbg=NONE")

-- formatter
require("formatter").setup(
  {
    filetype = {
      lua = {
        -- luafmt
        function()
          return {
            exe = "/usr/local/bin/luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)

-- ToggleTerm
require "toggleterm".setup {
  direction = "float"
}

-- Telescope
local telescope = require("telescope")
telescope.load_extension "file_browser"
telescope.load_extension "projects"

-- symbols
vim.g.symbols_outline = {
  width = 80
}

-- nvim tree
require "nvim-tree".setup {
  disable_netrw       = false,
  hijack_netrw        = false,
  update_cwd = false,
  update_focused_file = {
   enable = true,
   update_cwd = true,
   ignore_list = {}
 },
 view = {
   width = 40
 }
}

-- yank highlight
vim.g.highlightedyank_highlight_duration = 200

-- leetcode
vim.g.leetcode_browser = "firefox"
vim.g.leetcode_solution_filetype = "javascript"

-- nvim-cmp
local cmp = require "cmp"

-- override the global function to complete word from all buffers
get_bufnrs = function()
  return vim.api.nvim_list_bufs()
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

cmp.setup(
  {
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping(
        function(fallback)
          luasnip.expand_or_jump()
        end
        -- {
        --   i = cmp.mapping.abort(),
        --   c = cmp.mapping.close()
        -- }
      ),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end,
        {"i", "s"}
      ),
      ["<S-Tab>"] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
        {"i", "s"}
      )
    },
    sources = cmp.config.sources(
      {
        {name = "nvim_lsp"},
        -- {name = "vsnip"} -- For vsnip users.
        {name = "luasnip"}
      },
      {
        {name = "buffer"}
      }
    )
  }
)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  "/",
  {
    sources = {
      {name = "buffer"}
    }
  }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  {
    sources = cmp.config.sources(
      {
        {name = "path"}
      },
      {
        {name = "cmdline"}
      }
    )
  }
)

-- lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
local lspconfig = require "lspconfig"
local lsp_installer = require("nvim-lsp-installer")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = {noremap = true, silent = true}

  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  -- buf_set_keymap("n", "<leader>fd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  -- buf_set_keymap("n", "<leader>fd", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  -- illuminate integrated with lsp
  require 'illuminate'.on_attach(client)
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(
  function(server)
    local opts = {
      capabilities = capabilities,
      on_attach = on_attach
    }

    if server.name == "tsserver" or server.name == "tailwindcss" then
      opts.root_dir = function(fname)
        return lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname) or
          vim.fn.getcwd()
      end
    elseif server.name == "sumneko_lua" then
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = runtime_path
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {"vim"}
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true)
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false
          }
        }
      }
    end

    server:setup(opts)
  end
)

require "lsp_signature".setup()

-- treesitter
require "nvim-treesitter.configs".setup {
  ensure_installed = {"html", "css", "scss", "vim", "lua", "javascript", "typescript", "tsx", "json", "python", "vue", 'rust', 'bash', 'elm', 'elixir'},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
      scope_incremental = "<TAB>"
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
require("Comment").setup {
  pre_hook = function(ctx)
    local U = require "Comment.utils"

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location
    }
  end
}

-- autopairs
require("nvim-autopairs").setup {}
-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

-- nvim-gps
local gps = require "nvim-gps"
gps.setup()

-- lualine
local function tabStopStatus()
  return " " .. vim.api.nvim_get_option("tabstop")
end
require("lualine").setup {
  options = {
    -- theme = 'palenight',
    theme = "auto",
    component_separators = "|",
    section_separators = {left = "", right = ""}
  },
  sections = {
    lualine_a = {
      {"mode", separator = {left = ""}, right_padding = 2}
    },
    lualine_b = {
      {
        "filename",
        symbols = {
          modified = "*", -- Text to show when the file is modified.
          readonly = " ", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[Untitled]" -- Text to show for unnamed buffers.
        }
      },
      "branch",
      "diff"
    },
    lualine_c = {{gps.get_location, cond = gps.is_available}},
    lualine_x = {},
    lualine_y = {"filetype", "fileformat", tabStopStatus, "diagnostics"},
    lualine_z = {
      {"progress", separator = {right = ""}, left_padding = 2}
    }
  },
  inactive_sections = {
    lualine_a = {"filename"},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {"toggleterm", "fugitive", "nvim-tree"}
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
