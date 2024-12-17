return {
    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function()
                    local dap, dapui = require("dap"), require("dapui")
                    dapui.setup()
                    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
                    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
                    dap.listeners.before.event_exited["dapui_config"] = dapui.close
                end,
                keys = {
                    { "<F7>", "<cmd>lua require('dapui').toggle()<cr>", desc = "Debug: Show Last Session Result" },
                },
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = { "williamboman/mason.nvim" },
                ---@module 'mason-nvim-dap'
                ---@type MasonNvimDapSettings
                opts = {
                    handlers = {},
                    ensure_installed = { "delve" },
                    automatic_installation = false,
                },
            },
        },
        -- stylua: ignore
        keys = {
            -- Launch & Terminate
            { "<F5>", "<cmd>lua require('dap').continue()<cr>", desc = "Debug: Start/Continue" },
            { "<F10>", "<cmd>lua require('dap').terminate()<cr>", desc = "Debug: Terminate" },
            -- Step Through
            { "<F1>", "<cmd>lua require('dap').step_into()<cr>", desc = "Debug: Step Into" },
            { "<F2>", "<cmd>lua require('dap').step_over()<cr>", desc = "Debug: Step Over" },
            { "<F3>", "<cmd>lua require('dap').step_out()<cr>", desc = "Debug: Step Out" },
            -- Breakpoints
            { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Debug: Toggle Breakpoint" },
            { "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Debug: Breakpoint Condition" },
        },
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            dap_configurations = {
                {
                    type = "go",
                    name = "Attach Remote",
                    mode = "remote",
                    request = "attach",
                },
            },
        },
        keys = {
            { "<leader>tdn", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "[D]ebug [N]earest Go [T]est" },
            { "<leader>tdl", "<cmd>lua require('dap-go').debug_last_test()<cr>", desc = "[D]ebug [L]ast Go [T]est" },
        },
    },
}
