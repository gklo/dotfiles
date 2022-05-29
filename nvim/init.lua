vim.o.hidden = true
vim.o.backup = false
vim.o.writebackup = false

vim.o.termguicolors = true

vim.o.background = "dark"
--vim.o.guifont = "JetbrainsMono Nerd Font:h10"

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

vim.o.completeopt = "menuone,noselect"
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

-- remove trailing space
--autocmd BufWritePre * %s/\s\+$//e

-- fix syntax highlighting
vim.cmd("autocmd BufEnter * :syn sync fromstart")

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
vim.opt.fillchars:append({eob = " ", vert = "▏"})

-- enable replace preview
vim.o.inccommand = "split"

vim.o.wrap = false
vim.o.foldlevel = 20
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

require("init_plugins")
require("init_setup_plugins")
require("init_mapping")
