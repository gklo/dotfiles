-- Global settings
vim.g.mapleader = " "

-- Backup and file handling
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.opt.fixeol = false

-- Editing and indentation
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
vim.o.inccommand = "split"

-- Window and splits
vim.o.splitbelow = true
vim.o.splitright = true

vim.cmd("au CursorHold * checktime")

vim.cmd("autocmd BufNewFile,BufRead *.js set filetype=javascriptreact")

-- use clipboard by default
vim.o.clipboard = "unnamedplus"

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

-- native comment
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring() or
      get_option(filetype, option)
end

require("paq")({
  "savq/paq-nvim",
  "machakann/vim-sandwich",
  "tpope/vim-repeat",
  "nvim-treesitter/nvim-treesitter",
  "maxmellon/vim-jsx-pretty",
  "JoosepAlviste/nvim-ts-context-commentstring"
})

require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = {
    enable = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "v",
      node_decremental = "V"
    }
  }
})

-- pickers
vim.keymap.set("n", "<leader>ff", '<cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>', {})
vim.keymap.set("n", "<leader>fg", '<cmd>call VSCodeNotify("workbench.action.findInFiles")<CR>', {})
vim.keymap.set("n", "<leader>fb", '<cmd>call VSCodeNotify("workbench.action.showAllEditorsByMostRecentlyUsed")<CR>', {})
vim.keymap.set("n", "<leader>fg", '<cmd>call VSCodeNotify("periscope.resumeSearch")<CR>', {})

-- format and lsp
vim.keymap.set("n", "<leader>ef", function()
  vim.cmd('call VSCodeNotify("editor.action.formatDocument")')
  vim.cmd('call VSCodeNotify("eslint.executeAutofix")')
end, {})
vim.keymap.set("x", "<leader>ef", '<cmd>call VSCodeNotify("editor.action.formatSelection")<CR>', {})
vim.keymap.set("n", "gr", '<cmd>call VSCodeNotify("editor.action.goToReferences")<CR>', {})
vim.keymap.set("n", "<leader>rn", '<cmd>call VSCodeNotify("editor.action.rename")<CR>', {})

-- switch between windows
vim.keymap.set("n", "gw", '<cmd>call VSCodeNotify("workbench.action.navigateEditorGroups")<CR>', {})
-- close window
vim.keymap.set("n", "ZZ", '<cmd>call VSCodeNotify("workbench.action.closeEditorsInGroup")<CR>', {})

