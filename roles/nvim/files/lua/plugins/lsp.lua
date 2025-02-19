---@module 'lazy'
---@type LazySpec[]
return {
    -- Language Server Configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "saghen/blink.cmp",
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

                pyright = {
                    pyright = {
                        disableOrganizeImports = true,
                    },
                },

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
                        -- https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.32.1-standalone-strict/all.json
                        schemas = { kubernetes = { "k8s**.yaml", "kube*/*.yaml" } },
                        -- disable built-in schema store support to use SchemaStore.nvim
                        schemaStore = { enable = false, url = "" },
                    },
                },
            },
        },
        ---@param opts Opts
        config = function(_, opts)
            local capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

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

                        settings.json.schemas = vim.tbl_deep_extend("force", require("schemastore").json.schemas(), settings.json.schemas or {})

                        require("lspconfig").jsonls.setup({
                            settings = settings,
                            capabilities = capabilities,
                        })
                    end,

                    ["yamlls"] = function()
                        local settings = opts.servers.yamlls

                        settings.yaml.schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), settings.yaml.schemas or {})

                        require("lspconfig").yamlls.setup({
                            settings = settings,
                            capabilities = capabilities,
                        })
                    end,
                },
            })

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#sourcekit
            if vim.fn.executable("sourcekit-lsp") == 1 then
                require("lspconfig").sourcekit.setup({})
            end

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#dartls
            if vim.fn.executable("dart") == 1 then
                require("lspconfig").dartls.setup({})
            end
        end,
    },

    -- Automatically install LSPs, Debugger, Linter & Formatter to stdpath
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonUpdate" },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                -- DAP
                "debugpy",
                "delve",
                -- Linter
                "codespell",
                "ruff",
                -- Formatter
                "shfmt",
                "stylua",
            },
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

    -- Automatically format code on save
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                sh = { "shfmt" },
                lua = { "stylua" },
                python = function(bufnr)
                    if vim.fs.root(bufnr, { "pyproject.toml", "ruff.toml", ".ruff.toml" }) ~= nil then
                        return { "ruff_fix", "ruff_format", "ruff_organize_imports" }
                    else
                        return { lsp_format = "never" }
                    end
                end,
                ["*"] = function(bufnr)
                    if vim.fs.root(bufnr, ".codespellrc") ~= nil then
                        return { "codespell" }
                    else
                        return {}
                    end
                end,
                ["_"] = { "trim_whitespace" },
            },
            format_on_save = {
                timeout_ms = 500,
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        },
        init = function()
            vim.opt.formatexpr = "v:lua.require('conform').formatexpr()"
        end,
        keys = {
            { "<leader>f", "<cmd>lua require('conform').format({async=true})<cr>", desc = "[F]ormat" },
        },
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
