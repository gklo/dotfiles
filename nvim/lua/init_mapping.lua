local map = function(key)
  -- get the extra options
  local opts = { noremap = true }
  for i, v in pairs(key) do
    if type(i) == "string" then
      opts[i] = v
    end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end
-- cmdline
map { "c", "<c-a>", "<c-b>" }
map { "c", "<m-left>", "<s-left>" }
map { "c", "<m-right>", "<s-right>" }
map { "c", "<m-bs>", "<c-w>" }

-- copy
map { "n", "<leader>y", '"+y' }
map { "n", "<leader>yy", '"+yy' }
map { "x", "<leader>y", '"+y' }
map { "n", "<leader>p", 'o<esc>"+]p' }
map { "n", "<leader>P", 'O<esc>"+]P' }
-- indented paste
map { "n", "p", "]p" }

-- custom command
vim.cmd "command -nargs=1 -bar STab :set shiftwidth=<args> tabstop=<args> softtabstop=<args>"

-- toggleterm
map { "n", "<c-a>", '<Cmd>exe v:count1 . "ToggleTerm"<CR>' }
map { "t", "<c-a>", '<Cmd>exe v:count1 . "ToggleTerm"<CR>' }

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-w><c-w>', [[<C-\><C-n><c-w>w]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- lsp
local hasEslint = function()
  local clients = vim.lsp.get_active_clients()
  local result = false

  for _, x in pairs(clients) do
    if x['name'] == 'eslint' then
      result = true
    end
  end

  return result
end

function _G.my_format()

  if hasEslint() then
    vim.cmd 'EslintFixAll'
  else
    vim.lsp.buf.format({ async = true })
  end
end

map {'n', '<leader>ef', '<cmd>lua my_format()<cr>'}

-- telescope
map { "n", "<leader>ff", "<cmd>Telescope find_files<cr>" }
map { "n", "<leader>fg", "<cmd>Telescope live_grep<cr>" }
map { "n", "<leader>fb", "<cmd>Telescope buffers<cr>" }
map { "n", "<leader>fh", "<cmd>Telescope oldfiles<cr>" }
map { "n", "<leader>fH", "<cmd>Telescope help_tags<cr>" }
map { "n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>" }
map { "n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" }
map { "n", "<leader>fF", "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>" }
map { "n", "<leader>fd", "<cmd>Telescope diagnostics<cr>" }
map { "n", "<leader>fp", "<cmd>Telescope projects<cr>" }
map { "n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>" }

-- edit
map { "n", "<leader>ei", "gg=G<c-o>" }

-- diff view
map { "n", "<leader>do", ":DiffviewOpen " }
map { "n", "<leader>dc", ":DiffviewClose<CR>" }
map { "n", "<leader>df", ":DiffviewFileHistory %<CR>" }
map { "n", "<leader>dt", ":DiffviewToggleFiles<CR>" }

-- nvim-tree
map { "n", "<C-e>", ":NvimTreeFindFileToggle<CR>" }

-- hop
map { "n", "s", "<cmd>HopChar1<cr>" }
-- place this in one of your configuration file(s)
map { "n", "f",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "n", "F",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
map { "n", "t",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true,  hint_offset = -1 })<cr>" }
map { "n", "T",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>" }
map { "x", "f",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "x", "F",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
map { "x", "t",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true,  hint_offset = -1 })<cr>" }
map { "x", "T",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>" }
map { "o", "f",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "o", "F",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
map { "o", "t",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true,  hint_offset = -1 })<cr>" }
map { "o", "T",
"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>" }

-- lspsaga
map { "n", "gr", "<cmd>Lspsaga lsp_finder<CR>", { slient = true } }
map { "n", "gh", "<cmd>Lspsaga show_line_diagnostics<CR>", { slient = true } }
map { "n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { slient = true } }
map { "n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", { slient = true } }
map { "n", "gp", "<cmd>Lspsaga peek_definition<CR>", { silent = true } }
map { "n", "ga", "<cmd>Lspsaga code_action<CR>", { silent = true } }
