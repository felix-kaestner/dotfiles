-- Remap to quickly run tests in Go
vim.keymap.set("n", "<leader>gt", "<cmd>!go test -v %:p:h<cr>", { desc = "[G]o [T]est" })
