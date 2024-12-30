---@module 'lazy'
---@type LazySpec[]
return {
    -- Line and column number support
    "wsdjeg/vim-fetch",

    -- Netrw enhancements
    "tpope/vim-vinegar",

    -- Add/change/delete surrounding characters
    "tpope/vim-surround",

    -- Neovim lua library
    { "nvim-lua/plenary.nvim", lazy = true },

    -- Show pending keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        ---@module 'which-key'
        ---@type wk.Opts
        opts = {
            spec = {
                { "<leader>c", group = "[C]ode" },
                { "<leader>d", group = "[D]ocument" },
                { "<leader>w", group = "[W]orkspace" },
                { "<leader>g", group = "[G]it" },
                { "<leader>h", group = "[H]unk" },
                { "<leader>r", group = "[R]efactor" },
                { "<leader>s", group = "[S]earch" },
            },
        },
    },

    -- Zen-Mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        ---@module 'zen-mode'
        ---@type ZenOptions
        opts = {
            window = {
                options = { number = false },
            },
            plugins = {
                gitsigns = { enabled = true }, -- disables git signs
            },
        },
        keys = {
            { "<leader>z", "<cmd>lua require('zen-mode').toggle()<cr>", desc = "Toggle [Z]en-Mode" },
        },
    },

    -- Quick Navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        ---@module 'harpoon'
        ---@type HarpoonPartialConfig
        opts = {},
        config = function(_, opts)
            require("harpoon"):setup(opts)
            require("telescope").load_extension("harpoon")
        end,
        keys = {
            { "<C-m>", "<cmd>lua require('harpoon'):list():add()<cr>", desc = "[Harpoon] [M]ark File" },
            { "<C-h>", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", desc = "[Harpoon] Open Menu" },
            { "<leader>k", "<cmd>lua require('harpoon'):list():prev({ ui_nav_wrap = true })<cr>", desc = "[Harpoon] Navigate Previous" },
            { "<leader>j", "<cmd>lua require('harpoon'):list():next({ ui_nav_wrap = true })<cr>", desc = "[Harpoon] Navigate Next" },
            { "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<cr>", desc = "[Harpoon] Navigate to File 1" },
            { "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<cr>", desc = "[Harpoon] Navigate to File 2" },
            { "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<cr>", desc = "[Harpoon] Navigate to File 3" },
            { "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<cr>", desc = "[Harpoon] Navigate to File 4" },
        },
    },
}
