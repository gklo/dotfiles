-- copy via clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("x", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+]p')
vim.keymap.set("n", "<leader>P", '"+]P')

vim.keymap.set('n', 'gw', '<c-w>w')

vim.keymap.set('n', '<leader>ef', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep hidden=true<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>fs",
  "<cmd>lua require('telescope.builtin').lsp_document_symbols({ ignore_symbols = { 'property', 'variable' } })<cr>",
  { noremap = true })
vim.keymap.set("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>")

-- edit
vim.keymap.set("n", "<leader>ei", "gg=G<c-o>")

-- nvim-tree
vim.keymap.set("n", "<C-z>", ":NvimTreeFindFileToggle<CR>")

-- term
vim.keymap.set("n", "<leader>t", ":tabnew | term<CR>")

-- nvaigation
vim.keymap.set("n", "<C-j>", "<C-d>")
vim.keymap.set("n", "<C-k>", "<C-u>")
vim.keymap.set("n", "ZA", "<cmd>qa!")

-- lsp
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
vim.keymap.set("n", "gh", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")

vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>")
vim.keymap.set("n", "gv", "<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "H", "<cmd>lua vim.lsp.buf.hover()<cr>")
