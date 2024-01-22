-- Remap to quickly run tests in Go
vim.keymap.set("n", "<leader>gt", "<cmd>!go test -v %:p:h<cr>", { desc = "[G]o [T]est" })

-- Remap to quickly report test coverage in Go
vim.keymap.set("n", "<leader>tc", function()
    local Job = require("plenary.job")

    Job:new({
        command = "go",
        args = { "test", "-tags=test", "-coverprofile=c.out", vim.fn.expand("%:p:h") },
    }):sync()

    Job:new({
        command = "go",
        args = { "tool", "cover", "-html=c.out" },
    }):sync()
end, { desc = "[G]o [C]overage" })

