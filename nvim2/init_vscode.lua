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

--system
vim.o.mouse = "a"
vim.o.swapfile = false
vim.o.errorbells = false

--auto reload (first line is no enough)
vim.o.autoread = true
vim.cmd("au CursorHold * checktime")

-- fix backspace
vim.opt.backspace = { "eol", "start", "indent" }

--faster response time
vim.o.updatetime = 300
-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- set large redrawtime to make sure syntax highlight working all the time
vim.o.redrawtime = 10000

vim.o.foldnestmax = 1

-- vim.o.lazyredraw = true

-- remove trailing space
--autocmd BufWritePre * %s/\s\+$//e

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

--fix newline at the end of file (causing git changes)
vim.o.fixeol = false

--hide the tilde characters on the blank lines
--better diff looking
--[[ vim.opt.fillchars:append({ eob = " ", vert = "▏", diff = "╱" }) ]]
vim.opt.fillchars:append({ eob = " ", diff = "╱" })

-- enable replace preview
vim.o.inccommand = "split"

vim.o.wrap = false
-- disable terminal numbers
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")

vim.keymap.set("n", "gr", '<cmd>call VSCodeNotify("editor.action.goToReferences")<CR>', {})
vim.keymap.set("n", "<leader>rn", '<cmd>call VSCodeNotify("editor.action.rename")<CR>', {})
vim.keymap.set("n", "<leader>ff", '<cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>', {})
vim.keymap.set("n", "<leader>fg", '<cmd>call VSCodeNotify("workbench.action.findInFiles")<CR>', {})
vim.keymap.set(
	"n",
	"<leader>fb",
	'<cmd>call VSCodeNotify("workbench.action.showAllEditorsByMostRecentlyUsed")<CR>',
	{}
)
vim.keymap.set("n", "<leader>ef", '<cmd>call VSCodeNotify("editor.action.formatDocument")<CR>', {})
vim.keymap.set("x", "<leader>ef", '<cmd>call VSCodeNotify("editor.action.formatSelection")<CR>', {})

-- grep
vim.keymap.set("n", "<leader>fg", '<cmd>call VSCodeNotify("periscope.search")<CR>', {})

-- close window
vim.keymap.set("n", "ZZ", '<cmd>call VSCodeNotify("workbench.action.closeEditorsInGroup")<CR>', {})

-- switch between windows
vim.keymap.set("n", "gw", '<cmd>call VSCodeNotify("workbench.action.navigateEditorGroups")<CR>', {})



require("paq")({
	"savq/paq-nvim", -- Let Paq manage itself
	"machakann/vim-sandwich",
	"tpope/vim-repeat",
	"kana/vim-textobj-user",
	"sgur/vim-textobj-parameter",
	"machakann/vim-highlightedyank",
	"nvim-treesitter/nvim-treesitter",
	"NMAC427/guess-indent.nvim",
	"maxmellon/vim-jsx-pretty",
	"tpope/vim-commentary",
	"JoosepAlviste/nvim-ts-context-commentstring",
})

require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			node_incremental = "v",
			node_decremental = "V",
		},
	},
})

vim.g.highlightedyank_highlight_duration = 200

vim.o.clipboard = "unnamedplus"
