---@module 'lazy'
---@type LazySpec[]
return {
    -- Nerd Font Icons
    "nvim-tree/nvim-web-devicons",

    -- Set lualine as statusline
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "catppuccin-mocha",
                globalstatus = true,
                icons_enabled = true,
                section_separators = "",
                component_separators = "|",
                extensions = {
                    "fugitive",
                    "lazy",
                    "man",
                    "mason",
                    "nvim-dap-ui",
                    "quickfix",
                },
            },
            -- stylua: ignore
            sections = {
                lualine_a = { { "mode", fmt = function(str) return str:sub(1,1) end } },
                lualine_b = { { "filename", path = 1 } },
                lualine_c = { "branch", "diff", "diagnostics" },
            },
        },
    },

    -- Catppuccin Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        ---@module 'catppuccin'
        ---@type CatppuccinOptions
        opts = {
            integrations = {
                blink_cmp = true,
                copilot_vim = true,
                diffview = true,
                fidget = true,
                harpoon = true,
                mason = true,
                which_key = true,
            },
            transparent_background = true,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },

    -- Add indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        ---@module 'ibl'
        ---@type ibl.config
        opts = {
            scope = { enabled = false },
        },
    },
}
