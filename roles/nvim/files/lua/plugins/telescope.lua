---@module 'lazy'
---@type LazySpec[]
return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            -- Fuzzy Finder Algorithm
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            -- UI Select
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                extensions = {
                    ["fzf"] = {},
                    ["ui-select"] = {
                        require("telescope.themes").get_cursor(),
                    },
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
        keys = {
            -- Buffers & Files
            { "<leader>.", "<cmd>Telescope oldfiles<cr>", desc = "[?] Find recently opened files" },
            { "<leader><leader>", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "[ ] Find existing buffers" },
            { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
            -- Search
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
            { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "[S]earch [M]an Pages" },
            { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch [W]ord" },
            { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
            { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
            { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
            { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect" },
            { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find previewer=false<cr>", desc = "[/] Fuzzily search in current buffer" },
            -- Git
            { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Search [G]it [F]iles" },
            { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "[G]it [C]ommits" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "[G]it [B]ranches" },
            { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "[G]it [S]tatus" },
        },
    },

    --  GitHub Integration for Telescope
    {
        "nvim-telescope/telescope-github.nvim",
        config = function()
            require("telescope").load_extension("gh")
        end,
        keys = {
            { "<leader>ghi", "<cmd>Telescope gh issues<cr>", desc = "[G]itHub [I]ssues" },
            { "<leader>ghp", "<cmd>Telescope gh pull_request<cr>", desc = "[G]itHub [P]ull Request" },
            { "<leader>ghr", "<cmd>Telescope gh run<cr>", desc = "[G]itHub Workflow [R]un" },
        },
    },
}
