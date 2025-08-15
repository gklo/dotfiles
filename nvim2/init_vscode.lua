vim.g.mapleader = " "
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

-- system
vim.o.mouse = "a"
vim.o.swapfile = false
vim.o.errorbells = false

-- auto reload (first line is no enough)
vim.o.autoread = true
vim.cmd("au CursorHold * checktime")

-- fix backspace
vim.opt.backspace = { "eol", "start", "indent" }

-- faster response time
vim.o.updatetime = 300
-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- set large redrawtime to make sure syntax highlight working all the time
vim.o.redrawtime = 10000

vim.o.foldnestmax = 1

-- show pressed key
vim.o.showcmd = true

local osname = vim.uv.os_uname().sysname
if string.find(osname, "Windows") then
  vim.o.shell = "cmd"
elseif vim.fn.executable("fish") then
  vim.o.shell = "fish"
end

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.title = true
vim.o.titlestring = "%(%{expand('%:~:.:h')}%)\\%t"

-- fix newline at the end of file (causing git changes)
vim.o.fixeol = false

-- hide the tilde characters on the blank lines
-- better diff looking
--[[ vim.opt.fillchars:append({ eob = " ", vert = "▏", diff = "╱" }) ]]
vim.opt.fillchars:append({
  eob = " ",
  diff = "╱"
})

-- enable replace preview
vim.o.inccommand = "split"

vim.o.wrap = false
-- disable terminal numbers
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")

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
      vim.highlight.on_yank({
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

vim.keymap.set("n", "gr", '<cmd>call VSCodeNotify("editor.action.goToReferences")<CR>', {})
vim.keymap.set("n", "<leader>rn", '<cmd>call VSCodeNotify("editor.action.rename")<CR>', {})
vim.keymap.set("n", "<leader>ff", '<cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>', {})
vim.keymap.set("n", "<leader>fg", '<cmd>call VSCodeNotify("workbench.action.findInFiles")<CR>', {})
vim.keymap.set("n", "<leader>fb", '<cmd>call VSCodeNotify("workbench.action.showAllEditorsByMostRecentlyUsed")<CR>', {})

vim.keymap.set("n", "<leader>ef", function()
  vim.cmd('call VSCodeNotify("editor.action.formatDocument")')
  vim.cmd('call VSCodeNotify("eslint.executeAutofix")')
end, {})

vim.keymap.set("x", "<leader>ef", '<cmd>call VSCodeNotify("editor.action.formatSelection")<CR>', {})

-- grep
vim.keymap.set("n", "<leader>fg", '<cmd>call VSCodeNotify("periscope.search")<CR>', {})

-- close window
vim.keymap.set("n", "ZZ", '<cmd>call VSCodeNotify("workbench.action.closeEditorsInGroup")<CR>', {})

-- switch between windows
vim.keymap.set("n", "gw", '<cmd>call VSCodeNotify("workbench.action.navigateEditorGroups")<CR>', {})

require("paq")({ "savq/paq-nvim", -- Let Paq manage itself
  "machakann/vim-sandwich", "tpope/vim-repeat", "nvim-treesitter/nvim-treesitter", "maxmellon/vim-jsx-pretty",
  "JoosepAlviste/nvim-ts-context-commentstring", "sustech-data/wildfire.nvim" })

require("wildfire").setup()
-- native comment
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring() or
      get_option(filetype, option)
end

-- native yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', {
    clear = true
  }),
  callback = function()
    vim.hl.on_yank({
      higroup = 'IncSearch', -- Highlight group to use (can change to 'Visual' or another)
      timeout = 200,         -- Duration in ms before highlight clears
      on_macro = true,       -- Highlight during macro execution (default: false)
      on_visual = true       -- Highlight visual selections (default: true)
    })
  end
})

require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = {
    enable = false
  }
  --[[ incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "v",
      node_decremental = "V"
    }
  } ]]
})

vim.g.highlightedyank_highlight_duration = 200

vim.o.clipboard = "unnamedplus"
