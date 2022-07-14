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
map { "n", "<c-a>", "<cmd>ToggleTerm<CR>" }
map { "t", "<c-a>", "<cmd>ToggleTerm<CR>" }

-- telescope
map { "n", "<leader>ff", "<cmd>Telescope find_files<cr>" }
map { "n", "<leader>fg", "<cmd>Telescope live_grep<cr>" }
map { "n", "<leader>fG", '<cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<cr>' }
map { "n", "<leader>fb", "<cmd>Telescope buffers<cr>" }
map { "n", "<leader>fh", "<cmd>Telescope oldfiles<cr>" }
map { "n", "<leader>fH", "<cmd>Telescope help_tags<cr>" }
map { "n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>" }
map { "n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>" }
map { "n", "<leader>fF", "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>" }
map { "n", "<leader>fd", "<cmd>Telescope diagnostics<cr>" }

-- lsp

-- edit
map { "n", "<leader>ei", "gg=G<c-o>" }

-- diff view
map { "n", "<leader>do", ":DiffviewOpen " }
map { "n", "<leader>dc", ":DiffviewClose<CR>" }
map { "n", "<leader>df", ":DiffviewFileHistory %<CR>" }
map { "n", "<leader>dt", ":DiffviewToggleFiles<CR>" }

-- nvim-tree
map { "n", "<C-e>", ":NvimTreeFindFileToggle<CR>" }

-- SymbolsOutline
-- map {"n", "<leader>so", "<cmd>SymbolsOutline<cr>"}

-- hop
map { "n", "<leader>s", "<cmd>HopChar2<cr>" }
-- place this in one of your configuration file(s)
map { "n", "f",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "n", "F",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
map { "o", "f",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>" }
map { "o", "F",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>" }
map { "", "t",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>" }
map { "", "T",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>" }
