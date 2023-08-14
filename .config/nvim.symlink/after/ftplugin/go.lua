-- Remap to quickly run tests in Go
vim.keymap.set("n", "<leader>gt", "<cmd>!go test -v %:p:h<cr>", { buffer = bufnr, desc = "[G]o [T]est" })

