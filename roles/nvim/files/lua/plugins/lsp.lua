-- [[ LSP ]]

-- Language Server Configuration
local servers = {
    gopls = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            semanticTokens = true,
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
                unusedwrite = true,
                unusedparams = true,
                unusedvariable = true,
                fieldalignment = true,
            },
            codelenses = {
                test = true,
                gc_details = true,
            },
            hints = {
                constantValues = true,
            },
            -- TODO: remove
            buildFlags = { "-tags=test" },
        },
    },

    golangci_lint_ls = {},

    rust_analyzer = {},

    jsonls = {
        json = {
            ---@module 'schemastore'
            ---@type SchemaOpts?
            schemas = nil,
            validate = { enable = true },
        },
    },

    lua_ls = {
        Lua = {
            format = { enable = false },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
        },
    },

    pyright = {},

    terraformls = {
        experimentalFeatures = {
            validateOnSave = true,
            prefillRequiredFields = true,
        },
    },

    ts_ls = {},

    yamlls = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
            ---@module 'schemastore'
            ---@type SchemaOpts?
            schemas = nil,
            -- disable built-in schema store support to use SchemaStore.nvim
            schemaStore = { enable = false, url = "" },
        },
    },
}

-- Executed when the LSP connects to a particular buffer
---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
    local builtin = require("telescope.builtin")

    local map = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, nowait = true })
    end

    map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    map("<leader>gr", builtin.lsp_references, "[G]oto [R]eferences")
    map("<leader>gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]enses")

    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("<leader>cc", function()
        vim.lsp.buf.code_action({
            apply = true,
            filter = function(act)
                return act.isPreferred
            end,
        })
    end, "Apply [C]ode Action")

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

        map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, "T]oggle Inlay [H]ints")
    end

    -- Automatically format source code on save
    if client:supports_method("textDocument/formatting", bufnr) and client.name ~= "tsserver" then
        local augroup = vim.api.nvim_create_augroup("lsp-format", { clear = true })
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                if client.name == "gopls" then
                    -- Organize imports using the LSP
                    -- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
                    ---@diagnostic disable-next-line: missing-parameter
                    local params = vim.lsp.util.make_range_params()
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
                end

                -- Format the buffer using the LSP
                vim.lsp.buf.format({ async = false, bufnr = bufnr })
            end,
        })
    end
end

return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- Automatically install LSPs to stdpath
            { "williamboman/mason.nvim", cmd = { "Mason", "MasonUpdate" }, build = ":MasonUpdate", opts = {} },
            "williamboman/mason-lspconfig.nvim",

            -- SchemaStore catalog for jsonls and yamlls
            "b0o/schemastore.nvim",
        },
        config = function()
            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Setup mason-lspconfig so it can manage external tooling
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),

                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            settings = servers[server_name],
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["gopls"] = function()
                        local settings = servers.gopls


                        if vim.fn.executable("go") == 1 then
                            local Job = require("plenary.job")
                            Job:new({
                                command = "go",
                                args = { "list", "-m", "-f", "'{{.Path}}'" },
                                on_exit = function(job, code)
                                    if code ~= 0 then
                                        return
                                    end

                                    -- See: https://github.com/golang/tools/blob/master/gopls/doc/settings.md#local-string
                                    local module = table.concat(job:result()):gsub("'", "")
                                    settings.gopls["local"] = module

                                    if string.find(module, "aboutyou.com") then
                                        settings.gopls.analyses.deprecated = false
                                        settings.gopls.analyses.fieldalignment = false
                                        settings.gopls.analyses.unusedparams = false
                                    end
                                end,
                            }):sync()
                        end

                        require("lspconfig").gopls.setup({
                            settings = settings,
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["jsonls"] = function()
                        local settings = servers.jsonls

                        settings.json.schemas = require("schemastore").json.schemas(settings.json.schemas)

                        require("lspconfig").jsonls.setup({
                            settings = settings,
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["yamlls"] = function()
                        local settings = servers.yamlls

                        settings.yaml.schemas = require("schemastore").yaml.schemas(settings.yaml.schemas)

                        require("lspconfig").yamlls.setup({
                            settings = settings,
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,
                },
            })
        end,
    },

    -- Useful status updates for LSP
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },

    -- Additional LuaLS configuration for Neovim config and plugin development
    {
        "folke/lazydev.nvim",
        ft = "lua",
        ---@module 'lazydev'
        ---@type lazydev.Config
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
