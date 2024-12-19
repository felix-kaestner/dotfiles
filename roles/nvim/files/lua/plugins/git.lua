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
        }
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
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local map = function(keys, func, desc, expr)
                    vim.keymap.set({ "n", "v" }, keys, func, { buffer = bufnr, desc = desc, expr = expr })
                end

                -- Navigation
                map("]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gitsigns.nav_hunk("next")
                    end)
                    return "<Ignore>"
                end, "Next Hunk", true)

                map("[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gitsigns.nav_hunk("prev")
                    end)
                    return "<Ignore>"
                end, "Previous Hunk", true)

                -- Actions
                map("<leader>hr", gitsigns.reset_hunk, "Reset Hunk")
                map("<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
                map("<leader>hu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
                map("<leader>hS", gitsigns.stage_buffer, "Stage Buffer")
                map("<leader>hU", gitsigns.reset_buffer_index, "Reset Buffer Index")
                map("<leader>hR", gitsigns.reset_buffer, "Reset Buffer")
                map("<leader>hp", gitsigns.preview_hunk, "Preview Hunk Inline")
                map("<leader>hd", gitsigns.diffthis, "Diff Buffer")
                map("<leader>hb", function() gitsigns.blame_line({full = true}) end, "Blame Line")
                map("<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Current Line Blame")
            end,
        },
    },
}
