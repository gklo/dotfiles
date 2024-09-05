vim.g.mapleader = " "
vim.o.hidden = true
vim.o.backup = false
vim.o.writebackup = false

vim.o.termguicolors = true

vim.o.background = "dark"

vim.o.guifont = "JetbrainsMono Nerd Font:h10:#h-slight:#e-subpixelantialias"
if vim.g.neovide then
	vim.o.guifont = "JetbrainsMono Nerd Font:h13"
	vim.opt.linespace = 1
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0.1

	vim.keymap.set('v', '<D-c>', '"+y')        -- Copy
	vim.keymap.set('n', '<D-v>', '"+P')        -- Paste normal mode
	vim.keymap.set('v', '<D-v>', '"+P')        -- Paste visual mode
	vim.keymap.set('c', '<D-v>', '<C-R>+')     -- Paste command mode
	vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end)

	local map = vim.keymap
	map.set({ "n", "v" }, "<D-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	map.set({ "n", "v" }, "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	map.set({ "n" , "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

-- vim.o.cursorline = true
-- vim.o.signcolumn = "yes"
-- vim.o.number = true

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

-- vim.o.lazyredraw = true

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
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")

vim.cmd("autocmd BufNewFile,BufRead *.js set filetype=javascriptreact")

-- config lsp diagnostic
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
})
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Disable underline, it's very annoying
	underline = false,
	-- Enable virtual text, override spacing to 4
	virtual_text = { spacing = 4 },
	-- signs = true,
	signs = false,
	update_in_insert = false,
})

-- autocomplete
vim.o.pumheight = 10

-- yank highlight and preserve cursor position
local augroups = {}
augroups.yankpost = {
	save_cursor_position = {
		event = { "VimEnter", "CursorMoved" },
		pattern = "*",
		callback = function()
			cursor_pos = vim.fn.getpos(".")
		end,
	},

	highlight_yank = {
		event = "TextYankPost",
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200, on_visual = true })
		end,
	},

	yank_restore_cursor = {
		event = "TextYankPost",
		pattern = "*",
		callback = function()
			local cursor = vim.fn.getpos(".")
			if vim.v.event.operator == "y" then
				vim.fn.setpos(".", cursor_pos)
			end
		end,
	},
}
for group, commands in pairs(augroups) do
	local augroup = vim.api.nvim_create_augroup("AU_" .. group, { clear = true })

	for _, opts in pairs(commands) do
		local event = opts.event
		opts.event = nil
		opts.group = augroup
		vim.api.nvim_create_autocmd(event, opts)
	end
end

-- search
vim.o.incsearch = false

-- 0.8 features
-- vim.o.winbar = "%f"
vim.o.laststatus = 3

vim.g.neovide_scroll_animation_length = 0.3

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
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
				trigger_patterns = { "*" },
			})
		end,
	},

	-- colorscheme
	{
		"folke/tokyonight.nvim",
		config = function()
			-- vim.cmd [[colorscheme tokyonight-moon]]
			-- vim.cmd [[highlight WinSeparator guifg=grey]]
		end,
	},

	{
		"tamton-aquib/staline.nvim",
		config = function()
			require("staline").setup({
				sections = {
					left = { "cwd", "branch" },
					mid = {},
					right = { "line_column" },
				},
				mode_colors = {
					i = "#d4be98",
					n = "#84a598",
					c = "#8fbf7f",
					v = "#fc802d",
				},
				defaults = {
					true_colors = true,
					line_column = "%l:%c %y",
					-- branch_symbol = " "
				},
			})
		end,
	},
	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("telescope").setup({
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
				defaults = {
					file_ignore_patterns = { ".git", "node_modules", "vendor" },
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							preview_height = 0.6,
							preview_cutoff = 1,
						},
					},
				},
			})
		end,
	},
	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = {
					enabled = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						node_incremental = "v",
						node_decremental = "V",
					},
				},
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = { "tpope/vim-commentary" },
		config = function()
			require("ts_context_commentstring").setup({})
		end,
	},

	-- lsp
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason").setup()
			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup({
				ensure_installed = {
					"tailwindcss",
					"volar",
					"sqlls",
					"pyright",
					"marksman",
					"eslint",
					"cssls",
					"html",
					"yamlls",
					"jsonls",
					"tsserver",
				},
				automatic_installation = true,
				-- automatic_installation = true
			})

			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end

				local opts = { noremap = true, silent = true }

				-- if client.name == 'eslint' then
				--   vim.cmd('autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js,*.json EslintFixAll')
				-- end

				buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
				buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				buf_set_keymap("n", "gh", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
				buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

				buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
				buf_set_keymap("n", "gv", "<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<cr>", opts)
				buf_set_keymap("n", "H", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)

				if client.server_capabilities.documenthighlightprovider then
					vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
					vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
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

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
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

					if server_name == "tsserver" then
						opts.settings = {
							implicitProjectConfiguration = {
								-- checkJs = true
							},
						}
					end
					if server_name == "tsserver" or server_name == "tailwindcss" then
						opts.root_dir = function(fname)
							return lspconfig.util.root_pattern(".git", "package.json", "tsconfig.json", "jsconfig.json")(
								fname
							) or vim.fn.getcwd()
						end
					elseif server_name == "lua_ls" then
						opts.settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									-- Get the language server to recognize the `vim` global
									globals = {
										"vim",
										"require",
									},
								},
								workspace = {
									-- Make the server aware of Neovim runtime files
									library = vim.api.nvim_get_runtime_file("", true),
								},
							},
						}
					end

					require("lspconfig")[server_name].setup(opts)
				end,
			})
		end,
	},
	"neovim/nvim-lspconfig",
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"zbirenbaum/copilot.lua",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local copilot = require("copilot.suggestion")
			if cmp == nil then
				return
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = require("lspkind").cmp_format({
						maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						before = function(entry, vim_item)
							if entry.completion_item.detail ~= nil and entry.completion_item.detail ~= "" then
								vim_item.menu = " " .. entry.completion_item.detail
							end
							return vim_item
						end,
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif copilot.is_visible() then
							copilot.accept()
						elseif luasnip.expand_or_locally_jumpable() then -- locally makes it only jump when cursor gone back to the snippet region
							luasnip.expand_or_jump()
							-- elseif has_words_before() then
							--   cmp.complete()
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
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	"saadparwaiz1/cmp_luasnip",
	"johngrib/vim-game-code-break",
	{
		"yamatsum/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					timeout = 300,
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				enable_rename = false,
				enable_close_on_slash = false,
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
		opts = {
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)
				-- set no horizontal scroll
				vim.api.nvim_exec("set mousescroll=hor:0", true)
			end,
			hijack_cursor = true, -- keep cursor on the first letter
			renderer = {
				indent_width = 2,
				icons = {
					git_placement = "signcolumn",
					show = {
						folder_arrow = false,
					},
					glyphs = {
						folder = {
							default = "",
							open = "",
							symlink = "",
						},
					},
				},
				indent_markers = {
					enable = true,
				},
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
			},
			filters = {
				custom = {
					"^.git$",
					"^.github$",
				},
			},
			actions = {
				change_dir = {
					enable = false,
					restrict_above_cwd = true,
				},
			},
		},
	},
	{
		"maxmellon/vim-jsx-pretty",
	},
	{
		"NMAC427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "UIEnter" },
		config = function()
			require("hlchunk").setup({
				blank = {
					enable = false,
				},
				indent = {
					enable = false,
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
				},
			})
		end,
	},
	{
		"rmagatti/auto-session",
		dependencies = "nvim-tree/nvim-tree.lua",
		config = function()
			local api = require("nvim-tree.api")
			local function close_nvim_tree()
				api.tree.close()
			end
			-- local function open_nvim_tree()
			--   api.tree.open()
			-- end
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
				bypass_session_save_file_types = { "NvimTree" },
				-- fix nvim-tree
				pre_save_cmds = { close_nvim_tree },
			})
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd [[colorscheme kanagawa]]
		end,
	},
	{
		"pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				debounce_delay = 3000,
			})
		end,
	},
	{
		"lambdalisue/suda.vim",
		config = function()
			vim.g.suda_smart_edit = true
		end,
	},
	-- Lua
	{
		"0oAstro/dim.lua",
		dependencies = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
		config = function()
			require("dim").setup()
		end,
	},
	{ -- peek definition
		"dnlhc/glance.nvim",
		event = "VeryLazy",
		config = function()
			require("glance").setup({
				-- your configuration
			})
		end,
	},
	{ -- keep cursor in place after > or =
		"gbprod/stay-in-place.nvim",
		config = function()
			require("stay-in-place").setup()
		end,
	},
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("nordic").load()
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			messages = {
				view_error = "mini",
				view_warn = "mini",
				view = "mini",
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		config = function()
			-- vim.cmd [[colorscheme duskfox]]
		end,
	},
	{
		"MunifTanjim/prettier.nvim",
		dependencies = "jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("prettier").setup({
				bin = "prettierd",
				filetypes = {
					"json",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
			})
		end,
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	}
})

-- commands
require("mappings")

-- override
vim.cmd [[highlight WinSeparator guifg=darkgray1]]

vim.cmd [[autocmd VimEnter * silent! !prettierd restart]]
