local map = function(key)
  -- get the extra options
  local opts = {noremap = true}
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

-- copy
map {"o", "<leader>y", '"+y'}
map {"n", "<leader>p", 'o<esc>"+p'}
map {"n", "<leader>P", 'O<esc>"+P'}

-- custom command
vim.cmd "command -nargs=1 -bar STab :set shiftwidth=<args> tabstop=<args> softtabstop=<args>"

-- toggleterm
map {"n", "<C-A>", "<cmd>ToggleTerm<CR>"}
map {"t", "<C-A>", "<cmd>ToggleTerm<CR>"}

-- telescope
map {"n", "<leader>ff", "<cmd>Telescope find_files<cr>"}
map {"n", "<leader>fg", "<cmd>Telescope live_grep<cr>"}
map {"n", "<leader>fG", '<cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<cr>'}
map {"n", "<leader>fb", "<cmd>Telescope buffers<cr>"}
map {"n", "<leader>fh", "<cmd>Telescope oldfiles<cr>"}
map {"n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>"}
map {
  "n",
  "<leader>fF",
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>"
}
map {
  "n",
  "<leader>fd",
  "<cmd>Telescope diagnostics<cr>"
}

-- nvim-tree
map {"n", "<C-n>", ":NvimTreeFindFileToggle<CR>"}

-- SymbolsOutline
map {"n", "<leader>so", "<cmd>SymbolsOutline<cr>"}

-- hop
map {"n", "s", "<cmd>HopChar2<cr>"}
-- place this in one of your configuration file(s)
map { "n", "f", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "n", "F", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
map { "o", "f", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>" }
map { "o", "F", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>" }
map { "", "t", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "", "T", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
