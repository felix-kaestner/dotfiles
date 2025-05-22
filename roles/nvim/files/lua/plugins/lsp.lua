---@module 'lazy'
---@type LazySpec[]
return {
    -- Language Server Configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        opts = {
            ensure_installed = {
                "bashls",
                "gopls",
                "golangci_lint_ls",
                "jsonls",
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "terraformls",
                "ts_ls",
                "yamlls",
            },
        },
        config = function(_, opts)
            -- Setup mason-lspconfig so it can manage external tooling
            require("mason-lspconfig").setup({
                ensure_installed = opts.ensure_installed,
            })

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#sourcekit
            if vim.fn.executable("sourcekit-lsp") == 1 then
                vim.lsp.enable("sourcekit")
            end

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#dartls
            if vim.fn.executable("dart") == 1 then
                vim.lsp.enable("dartls")
            end

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tilt_ls
            if vim.fn.executable("tilt") == 1 then
                vim.lsp.enable("tilt_ls")
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
                "shellcheck",
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
                go = { lsp_format = "prefer" },
                python = function(bufnr)
                    if vim.fs.root(bufnr, { "ruff.toml", ".ruff.toml" }) ~= nil then
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

    -- SchemaStore catalog for jsonls and yamlls
    { "b0o/schemastore.nvim", lazy = true },

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
