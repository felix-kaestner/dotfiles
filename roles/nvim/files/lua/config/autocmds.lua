-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("term-open", { clear = true }),
    pattern = "*",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.cmd.startinsert()
    end,
})

-- Organize imports on save
-- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params(0, "utf-8")
        params["context"] = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lsp-codelens", { clear = true }),
    pattern = { "*.go", "*.mod" },
    callback = function()
        if #vim.lsp.get_clients({ bufnr = 0, name = "gopls" }) > 0 then
            vim.lsp.codelens.refresh({ bufnr = 0 })
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("tab-indent", { clear = true }),
    pattern = { "go", "make" },
    callback = function()
        -- Disable listchars for files with tabs
        vim.opt_local.list = false
    end,
})
