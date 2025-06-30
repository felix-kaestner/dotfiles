---@module 'lazy'
---@type LazySpec[]
return {
    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui", "leoluz/nvim-dap-go", "mfussenegger/nvim-dap-python" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close
        end,
        keys = {
            -- Step Through
            { "<F1>", "<cmd>lua require('dap').step_into()<cr>", desc = "Debug: Step Into" },
            { "<F2>", "<cmd>lua require('dap').step_over()<cr>", desc = "Debug: Step Over" },
            { "<F3>", "<cmd>lua require('dap').step_out()<cr>", desc = "Debug: Step Out" },
            -- Launch & Terminate
            { "<F5>", "<cmd>lua require('dap').continue()<cr>", desc = "Debug: Start/Continue" },
            { "<F7>", "<cmd>lua require('dapui').toggle()<cr>", desc = "Debug: Show Last Session" },
            { "<F10>", "<cmd>lua require('dap').terminate()<cr>", desc = "Debug: Terminate" },
            { "<F12>", "<cmd>lua require('dap').run_last()<cr>", desc = "Debug: Run Last Configuration" },
            -- Breakpoints
            { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Debug: Toggle Breakpoint" },
            { "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Debug: Breakpoint Condition" },
        },
    },
    -- Go (delve) Configuration
    {
        "leoluz/nvim-dap-go",
        opts = {},
        keys = {
            { "<leader>tdn", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "Go: [D]ebug [N]earest" },
            { "<leader>tdl", "<cmd>lua require('dap-go').debug_last_test()<cr>", desc = "Go: [D]ebug [L]ast" },
        },
    },
    -- Python (debugpy) Configuration
    {
        "mfussenegger/nvim-dap-python",
        ---@module 'dap-python'
        ---@type dap-python.setup.opts
        opts = {},
        config = function(_, opts)
            require("dap-python").setup("uv", opts)
        end,
        keys = {
            { "<leader>dm", "<cmd>lua require('dap-python').test_method()<cr>", desc = "Python: [D]ebug [M]ethod" },
            { "<leader>dc", "<cmd>lua require('dap-python').test_class()<cr>", desc = "Python: [D]ebug [C]lass" },
        },
    },
    -- Asynchronous IO library
    { "nvim-neotest/nvim-nio", lazy = true },
}
