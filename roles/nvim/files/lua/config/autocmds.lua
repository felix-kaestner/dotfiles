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
        vim.cmd.startinsert()
    end,
})

local kubernetes = "kubernetes"
local file = vim.fn.expand("~/.cache/k8s-schemas/all.json")
if vim.fn.filereadable(file) == 1 then
    kubernetes = file
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(args)
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
        end

        local builtin = require("telescope.builtin")
        map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("<leader>gr", builtin.lsp_references, "[G]oto [R]eferences")
        map("<leader>gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]enses")

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        if client.name == "ruff" then
            -- Disable hover in favor of pyright
            client.server_capabilities.hoverProvider = false
        end

        -- Automatically discover kubernetes schema inside yaml files
        if client.name == "yamlls" then
            local res = client:request_sync("yaml/get/jsonSchema", { vim.uri_from_bufnr(args.buf) }, 500, args.buf)
            if res and #res.result == 0 then
                local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
                for _, line in ipairs(lines) do
                    if line:match("^kind: ") then
                        client:notify("json/schemaAssociations", { [kubernetes] = vim.uri_from_bufnr(args.buf) })
                        break
                    end
                end
            end
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

            map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
            end, "[T]oggle Inlay [H]ints")
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = augroup,
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = augroup,
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(event)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = event.buf })
                end,
            })
        end
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
    pattern = "go",
    callback = function()
        vim.opt_local.list = false
    end,
})

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("last-position", { clear = true }),
    pattern = "*",
    callback = function(opts)
        vim.api.nvim_create_autocmd("BufWinEnter", {
            once = true,
            buffer = opts.buf,
            callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                if not ft:match("commit") and not ft:match("rebase") and last > 1 and last <= vim.api.nvim_buf_line_count(opts.buf) then
                    vim.api.nvim_feedkeys([[g`"zz]], "nx", false)
                end
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("auto-resize", { clear = true }),
    pattern = "*",
    command = "normal! <C-w>=",
})

-- Support for v0.11 'vim.opt.winborder' in telescope
-- See: https://github.com/nvim-telescope/telescope.nvim/issues/3436
vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("telescope-winborder", { clear = true }),
    pattern = "TelescopeFindPre",
    callback = function()
        local border = vim.opt.winborder:get()
        vim.opt_local.winborder = "none"
        vim.api.nvim_create_autocmd("WinLeave", {
            once = true,
            callback = function()
                vim.opt_local.winborder = border
            end,
        })
    end,
})
