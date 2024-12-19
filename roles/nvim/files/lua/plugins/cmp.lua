return {
    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Sources
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            -- Icons
            "onsails/lspkind-nvim",

            -- Snippets
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "saadparwaiz1/cmp_luasnip",
            {
                -- Set of preconfigured snippets for different languages
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "go" } })
                    -- stylua: ignore
                    require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
                end,
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        menu = {
                            buffer = "[Buf]",
                            luasnip = "[Snip]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[API]",
                            path = "[Path]",
                        },
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-L>"] = cmp.mapping(function(fallback)
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "lazydev" },
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "path" },
                },
                experimental = {
                    ghost_text = false,
                },
            })
        end,
    },

    -- Automatically insert closing tags
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
            require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        enabled = false,
        keys = {
            { "<C-K>", 'copilot#Accept("")', mode = "i", expr = true, replace_keycodes = false },
            { "<C-[>", "copilot#Previous()", mode = "i", expr = true },
            { "<C-]>", "copilot#Next()", mode = "i", expr = true },
        },
    },
}
