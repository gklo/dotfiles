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
-- map { "n", "<leader>p", 'o<esc>"+]p' }
-- map { "n", "<leader>P", 'O<esc>"+]P' }
map { "n", "<leader>p", '"+]p' }
map { "n", "<leader>P", '"+]P' }
-- indented paste
map { "n", "p", "]p" }
map { "n", "P", "]P" }
-- vim.keymap.set({"x"}, "p", "<Plug>(YankyPutAfter)")
-- vim.keymap.set({"x"}, "P", "<Plug>(YankyPutBefore)")
-- vim.keymap.set({"n"}, "p", "<Plug>(YankyPutIndentAfter)")
-- vim.keymap.set({"n"}, "P", "<Plug>(YankyPutIndentBefore)")
-- vim.keymap.set({"n","x"}, "gp", "]<Plug>(YankyGPutAfter)")
-- vim.keymap.set({"n","x"}, "gP", "]<Plug>(YankyGPutBefore)")
-- vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")

map {'n','gw', '<c-w>w'}

-- custom command
vim.cmd "command -nargs=1 -bar STab :set shiftwidth=<args> tabstop=<args> softtabstop=<args>"

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

map { 'n', '<leader>ef', '<cmd>lua my_format()<cr>' }

-- telescope
map { "n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>" }
map { "n", "<leader>fg", "<cmd>Telescope live_grep hidden=true<cr>" }
map { "n", "<leader>fb", "<cmd>Telescope buffers<cr>" }
map { "n", "<leader><leader>", "<cmd>Telescope buffers<cr>" }
map { "n", "<leader>fh", "<cmd>Telescope oldfiles hidden=true<cr>" }
map { "n", "<leader>fH", "<cmd>Telescope help_tags<cr>" }
-- map { "n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>" }
map { "n", "<leader>fs", "<cmd>lua require('telescope.builtin').lsp_document_symbols({ ignore_symbols = { 'property', 'variable' } })<cr>" }
map { "n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" }
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

-- term
map { "n", "<leader>t", ":tabnew | term<CR>" }


-- diagnostics
-- map { 'n', '<tab>', ':cn<cr>' }
-- map { 'n', '<s-tab>', ':cp<cr>' }

-- lsp
map { "n", "gr", "<cmd>Telescope lsp_references<CR>", { slient = true } }
map { "n", "gv", "<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<cr>", { silent = true } }
map { "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { silent = true } }
map { "n", "H", "<cmd>lua vim.diagnostic.open_float()<cr>", { silent = true } }
