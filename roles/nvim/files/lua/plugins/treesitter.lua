---@module 'lazy'
---@type LazySpec[]
return {
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        main = "nvim-treesitter.configs",
        priority = 100,
        dependencies = {
            -- Syntax aware text-objects, select, move, swap, and peek support
            "nvim-treesitter/nvim-treesitter-textobjects",

            -- Show the local context of the currently visible buffer contents
            {
                "nvim-treesitter/nvim-treesitter-context",
                main = "treesitter-context",
            },
        },
        opts = {
            auto_install = true,
            ensure_installed = {
                "git_config",
                "gitcommit",
                "git_rebase",
                "gitignore",
                "gitattributes",
                "go",
                "gomod",
                "gosum",
                "gotmpl",
                "gowork",
                "helm",
                "lua",
                "rust",
                "json5",
                "markdown",
                "dockerfile",
                "fish",
                "tsx",
                "javascript",
                "typescript",
                "python",
                "terraform",
                "hcl",
                "vimdoc",
                "vim",
                "yaml",
            },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]a"] = "@parameter.inner",
                        ["]c"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]A"] = "@parameter.inner",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[a"] = "@parameter.inner",
                        ["[c"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[A"] = "@parameter.inner",
                        ["[C"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            },
        },
    },

    -- Refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        cmd = "Refactor",
        keys = {
            { "<leader>re", "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", desc = "[R]efactor" },
            { "<leader>ri", "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", desc = "[R]efactor [I]nline Variable" },
        },
        config = function()
            require("telescope").load_extension("refactoring")
        end,
    },
}
