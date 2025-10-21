-- copy via clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("x", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+]p')
vim.keymap.set("n", "<leader>P", '"+]P')

-- editing
vim.keymap.set("n", "|", ":r!")

-- nvaigation
vim.keymap.set("n", "<C-j>", "<C-d>")
vim.keymap.set("n", "<C-k>", "<C-u>")
vim.keymap.set('n', 'gw', '<c-w>w')
vim.keymap.set("n", "<M-o>", "<cmd>bp<CR>")
vim.keymap.set("n", "<M-i>", "<cmd>bn<CR>")
vim.keymap.set("n", "ga", "<C-^>")

-- lsp
vim.keymap.set('n', '<leader>ef', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")

vim.keymap.set("n", "gv", "<cmd>vsplit<CR><cmd>lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gx", "<cmd>split<CR><cmd>lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "H", "<cmd>lua vim.lsp.buf.hover()<cr>")
