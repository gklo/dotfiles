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
-- map { "n", "p", "]p" }
-- map { "n", "P", "]P" }

map { 'n', 'gw', '<c-w>w' }

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
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf()
  })
  local result = false

  for _, x in pairs(clients) do
    if x['name'] == 'eslint' then
      result = true
    end
  end

  return result
end

-- Format by conform
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ lsp_format = "fallback", range = range })
end, { range = true })

function _G.custom_format()
  if hasEslint() then
    vim.cmd 'LspEslintFixAll'
    vim.cmd 'Format'
  else
    vim.lsp.buf.format({ async = true })
  end

  vim.lsp.buf.format({ async = true })
end

map { 'n', '<leader>ef', '<cmd>lua custom_format()<cr>' }

-- telescope
map { "n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>" }
map { "n", "<leader>fg", "<cmd>Telescope live_grep hidden=true<cr>" }
map { "n", "<leader>fb", "<cmd>Telescope buffers<cr>" }
map { "n", "<leader><leader>", "<cmd>Telescope buffers<cr>" }
map { "n", "<leader>fh", "<cmd>Telescope help_tags<cr>" }
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
map { "n", "<C-z>", ":NvimTreeFindFileToggle<CR>" }

-- term
map { "n", "<leader>t", ":tabnew | term<CR>" }

-- nvaigation
map { "n", "<C-j>", "<C-d>" }
map { "n", "<C-k>", "<C-u>" }
map { "n", "ZA", "<cmd>qa!" }

-- diagnostics
-- map { 'n', '<tab>', ':cn<cr>' }
-- map { 'n', '<s-tab>', ':cp<cr>' }

-- lsp
map { 'n', 'gp', '<CMD>Glance definitions<CR>' }

map { 'o', 'm', ":<C-U>lua require('tsht').nodes()<CR>", { slient = true } }
map { 'x', 'm', ":lua require('tsht').nodes()<CR>", { slient = true } }
