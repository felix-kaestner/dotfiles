return {
    -- Language Server Configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",

            -- SchemaStore catalog for jsonls and yamlls
            "b0o/schemastore.nvim",
        },
        ---@class Opts
        opts = {
            servers = {
                gopls = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        semanticTokens = true,
                        usePlaceholders = true,
                        completeUnimported = true,
                        analyses = {
                            shadow = true,
                            unusedwrite = true,
                            unusedparams = true,
                            unusedvariable = true,
                        },
                        codelenses = {
                            test = true,
                            gc_details = true,
                        },
                        hints = {
                            constantValues = true,
                        },
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
            },
        },
        ---@param opts Opts
        config = function(_, opts)
            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- Setup mason-lspconfig so it can manage external tooling
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(opts.servers),

                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            settings = opts.servers[server_name],
                            capabilities = capabilities,
                        })
                    end,

                    ["gopls"] = function()
                        local settings = opts.servers.gopls

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
                        })
                    end,

                    ["jsonls"] = function()
                        local settings = opts.servers.jsonls

                        settings.json.schemas = require("schemastore").json.schemas(settings.json.schemas)

                        require("lspconfig").jsonls.setup({
                            settings = settings,
                            capabilities = capabilities,
                        })
                    end,

                    ["yamlls"] = function()
                        local settings = opts.servers.yamlls

                        settings.yaml.schemas = require("schemastore").yaml.schemas(settings.yaml.schemas)

                        require("lspconfig").yamlls.setup({
                            settings = settings,
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },

    -- Automatically install LSPs, Debugger, Linter & Formatter to stdpath
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonUpdate" },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = { "debugpy", "delve" },
        },
        config = function(_, opts)
            require("mason").setup()

            local registry, Package = require("mason-registry"), require("mason-core.package")
            registry.refresh(vim.schedule_wrap(function()
                for _, identifier in ipairs(opts.ensure_installed) do
                    local name, version = Package.Parse(identifier)
                    local pkg = registry.get_package(name)
                    if not pkg:is_installed() then
                        vim.notify(("[mason.nvim] installing %s"):format(pkg.name))
                        pkg:install({ version = version }):once(
                            "closed",
                            vim.schedule_wrap(function()
                                if pkg:is_installed() then
                                    vim.notify(("[mason.nvim] %s was successfully installed"):format(pkg.name))
                                end
                            end)
                        )
                    end
                end
            end))
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
