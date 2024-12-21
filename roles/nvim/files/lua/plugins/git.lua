return {
    -- Git Integration
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "shumphrey/fugitive-gitlab.vim",

    -- Git Worktree Operations
    {
        "ThePrimeagen/git-worktree.nvim",
        config = function()
            local wt = require("git-worktree")

            wt.setup()
            require("telescope").load_extension("git_worktree")

            -- Update the working directory of the current tmux session when switching between worktrees
            if os.getenv("TMUX") ~= nil then
                wt.on_tree_change(function(op, metadata)
                    if op == wt.Operations.Switch then
                        -- stylua: ignore
                        vim.fn.system("tmux attach-session -t . -c " .. require("git-worktree").get_worktree_path(metadata.path))
                    end
                end)
            end
        end,
        -- stylua: ignore
        keys = {
            { "<leader>gwl", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", desc = "Switch [G]it [W]orktree" },
            { "<leader>gwc", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", desc = "Create [G]it [W]orktree" },
        },
    },

    -- Git Diff View
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        ---@module 'diffview'
        ---@type DiffviewConfig
        opts = {
            view = {
                merge_tool = {
                    layout = "diff4_mixed",
                },
            },
        },
        keys = {
            { "<leader>gd", "<cmd>lua require('diffview').open()<cr>", desc = "[G]it [D]iff" },
            { "<leader>gl", "<cmd>lua require('diffview').file_history()<cr>", desc = "[G]it [L]og" },
        },
    },

    -- Git Decorations
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            -- stylua: ignore
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local map = function(mode, keys, func, desc)
                    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end)

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Hunk")
                map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
                map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>hS", gitsigns.stage_buffer, "Stage Buffer")
                map("n", "<leader>hR", gitsigns.reset_buffer, "Reset Buffer")
                map("n", "<leader>hU", gitsigns.reset_buffer_index, "Reset Buffer Index")
                map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Hunk Inline")
                map("n", "<leader>hd", gitsigns.diffthis, "Diff Buffer")
                map("n", "<leader>hb", gitsigns.blame_line, "Blame Line")
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Current Line Blame")

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
}
