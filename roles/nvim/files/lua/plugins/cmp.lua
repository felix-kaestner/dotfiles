---@module 'lazy'
---@type LazySpec[]
return {
    -- Autocompletion
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        tag = "v0.11.0",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                nerd_font_variant = "normal",
                use_nvim_cmp_as_default = true,
            },
            completion = {
                menu = {
                    auto_show = function(ctx)
                        return ctx.mode ~= "cmdline"
                    end,
                },
                list = {
                    selection = {
                        auto_insert = function(ctx)
                            return ctx.mode == "cmdline"
                        end,
                    },
                },
                documentation = { auto_show = true },
            },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            signature = { enabled = true },
        },
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        keys = {
            { "<C-K>", 'copilot#Accept("")', mode = "i", expr = true, replace_keycodes = false },
            { "<C-[>", "copilot#Previous()", mode = "i", expr = true },
            { "<C-]>", "copilot#Next()", mode = "i", expr = true },
        },
    },
}
