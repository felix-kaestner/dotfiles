-- [[ Setting options ]]
-- See `:help vim.o`

-- Set <space> as the leader keyinit
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Show relative line numbers
vim.wo.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
-- See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Disable line wrapping
vim.wo.wrap = false

-- Save undo history
vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Set Scrolloff to 8 lines
vim.o.scrolloff = 8

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Enable spell checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Enable the use of 24-bit true color
-- NOTE: Make sure the terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Remap <Space> to <Nop> to avoid conflicts with leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>")

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Automatically center the cursor when moving up or down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Tabs
vim.keymap.set("n", "<C-T>", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<C-N>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<C-P>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<C-X>", "<cmd>tabclose<cr>")

-- Open/Close Quicklist
-- stylua: ignore
vim.keymap.set("n", "<leader>co", "getqflist({'winid':0}).winid == 0 ? ':copen<cr>' : ':cclose<cr>'", { expr = true, silent = true })

-- Paste over without replacing default register
vim.keymap.set({ "x", "v" }, "<leader>p", '"_dP')

-- Stay in visual mode while indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move selected line / block of text in visual mode
-- See: https://vim.fandom.com/wiki/Moving_lines_up_or_down#Mappings_to_move_lines
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- Search & Replace
-- stylua: ignore
vim.keymap.set({ "c", "n", "v", "x" }, "<C-S>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left><Left>]], { desc = "[S]earch & [R]eplace" })

-- Shorthand to launch Git pane
vim.keymap.set("n", "<leader>gp", vim.cmd.Git, { desc = "[G]it [P]ane"} )

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- [[ Fold using Treesitter ]]
-- See https://github.com/nvim-treesitter/nvim-treesitter#folding
vim.opt.foldlevel = 69
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- [[ LSP ]]

-- Language Server Configuration
local servers = {
    gopls = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            semanticTokens = true,
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
                unusedwrite = true,
                unusedparams = true,
                unusedvariable = true,
                fieldalignment = true,
            },
            buildFlags = { "-tags=test" }
        },
    },

    golangci_lint_ls = {},

    rust_analyzer = {},

    jsonls = {},

    lua_ls = {
        Lua = {
            format = { enable = false },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
            diagnostics = { disable = { "missing-fields" } },
        },
    },

    terraformls = {
        experimentalFeatures = {
            validateOnSave = true,
            prefillRequiredFields = true,
        },
    },

    tsserver = {},

    yamlls = {},
}

local augroup = vim.api.nvim_create_augroup("lsp-format", {})

-- Executed when the LSP connects to a particular buffer
local on_attach = function(client, bufnr)
    local builtin = require("telescope.builtin")

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-K>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Automatically format source code on save
    if client.supports_method("textDocument/formatting") and client.name ~= "tsserver" then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                if client.name == "gopls" then
                    -- Organize imports using the LSP
                    -- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
                    local params = vim.lsp.util.make_range_params()
                    params.context = { only = { "source.organizeImports" } }
                    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                    for cid, res in pairs(result or {}) do
                        for _, r in pairs(res.result or {}) do
                            if r.edit then
                                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                            end
                        end
                    end
                end

                -- Format the buffer using the LSP
                vim.lsp.buf.format({ async = false, bufnr = bufnr })
            end,
        })
    end
end

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- See `:help lazy.nvim.txt`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
-- Use the `:Lazy` command to manage
require("lazy").setup({
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",

            -- Useful status updates for LSP
            { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = { window = { blend = 0 } } },

            -- Additional lua configuration for Neovim setup and plugin development
            { "folke/neodev.nvim", opts = {} },
        },
        keys = {
            -- Diagnostic keymaps
            { "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic message" },
            { "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic message" },
            { "<leader>e", vim.diagnostic.open_float, desc = "Open floating diagnostic message" },
            { "<leader>q", vim.diagnostic.setloclist, desc = "Open buffer diagnostics list" },
            { "<leader>Q", vim.diagnostic.setqflist, desc = "Open diagnostics list" },
        },
        config = function()
            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Setup mason-lspconfig so it can manage external tooling
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    if server_name == "gopls" then
                        local Job = require("plenary.job")

                        Job:new({
                            command = "go",
                            args = { "list", "-m", "-f", "'{{.Path}}'" },
                            on_exit = function(job, code)
                                if code ~= 0 then
                                    return
                                end

                                local module = table.concat(job:result()):gsub("'", "")
                                servers[server_name].gopls["local"] = module

                                if module == "tadarida.aboutyou.com" then
                                    servers[server_name].gopls.analyses.deprecated = false
                                    servers[server_name].gopls.analyses.fieldalignment = false
                                    servers[server_name].gopls.analyses.unusedparams = false
                                end
                            end,
                        }):sync()
                    end

                    require("lspconfig")[server_name].setup({
                        settings = servers[server_name],
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
            })

            require("lspconfig").dartls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end,
    },

    -- Automatically install LSPs to stdpath
    { "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate", opts = {} },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            "onsails/lspkind-nvim",

            -- Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            {
                -- Set of preconfigured snippets for different languages
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
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
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping(function(fallback)
                        if not cmp.visible() then
                            cmp.complete()
                        elseif luasnip.expandable() then
                            luasnip.expand()
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
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                experimental = {
                    ghost_text = false,
                },
            }
        end,
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

    -- Highlight, edit, and navigate code using a fast incremental parsing library
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- Syntax aware text-objects, select, move, swap, and peek support
            "nvim-treesitter/nvim-treesitter-textobjects",

            -- Show the local context of the currently visible buffer contents
            {
                "nvim-treesitter/nvim-treesitter-context",
                main = "treesitter-context",
            },
        },
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = { "go", "gomod", "gosum", "gowork", "lua", "rust", "dockerfile", "json", "tsx", "typescript", "vimdoc", "vim", "yaml" },
            highlight = { enable = true },
            indent = { enable = true },
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
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
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
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>rr", "<cmd>lua require('refactoring').select_refactor()<cr>", desc = "[R]efactor" },
        },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",

            -- Fuzzy Finder Algorithm
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        -- See: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
        opts = function()
            local config = require("telescope.config")
            local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }

            local args = { "--hidden", "--glob", "!**/.git/*" }
            for _, arg in ipairs(args) do
                table.insert(vimgrep_arguments, arg)
            end

            return {
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", unpack(args) },
                    },
                },
            }
        end,
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("fzf")
        end,
        -- stylua: ignore
        keys = {
            -- Buffers & Files
            { "<leader>?", "<cmd>Telescope oldfiles<cr>", desc = "[?] Find recently opened files" },
            { "<leader><space>", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "[ ] Find existing buffers" },
            { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[/] Fuzzily search in current buffer" },
            { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
            { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Search [G]it [F]iles" },
            -- Search
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
            { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch [W]ord" },
            { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
            { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
            { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
            { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect" },
            -- Git
            { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "[G]it [C]ommits" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "[G]it [B]ranches" },
            { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "[G]it [S]tatus" },
            -- Theme
            { "<leader>st", function ()
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local finders = require("telescope.finders")
                local pickers = require("telescope.pickers")
                local conf = require("telescope.config").values
                local Job = require("plenary.job")

                pickers.new({}, {
                    prompt_title = "Switch Theme",
                    finder = finders.new_table { results = { "latte", "frappe", "macchiato", "mocha" } },
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr)
                        actions.select_default:replace(function()
                            actions.close(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            vim.cmd("colorscheme catppuccin-" .. selection.value)
                            Job:new({
                                command = vim.loop.os_homedir() .. "/.local/bin/theme-switcher",
                                args = { selection.value },
                            }):sync()
                        end)

                        return true
                    end,
                }):find()
            end, desc = "[S]witch [T]heme" },
        },
    },

    -- Telescope Integration for GitHub
    {
        "nvim-telescope/telescope-github.nvim",
        keys = {
            { "<leader>ghi", "<cmd>Telescope gh issues<cr>", desc = "[G]itHub [I]ssues" },
            { "<leader>ghp", "<cmd>Telescope gh pull_request<cr>", desc = "[G]itHub [P]ull Request" },
            { "<leader>ghr", "<cmd>Telescope gh run<cr>", desc = "[G]itHub Workflow [R]un" },
        },
        config = function()
            require("telescope").load_extension("gh")
        end,
    },

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>fe", "<cmd>NvimTreeFindFileToggle<cr>", desc = "[F]ile [E]xplorer" },
        },
        opts = {
            view = { width = "30%" },
            filters = { custom = { "^\\.git" } },
            update_focused_file = { enable = true },
            diagnostics = { enable = true },
        },
    },

    -- Quick Navigation
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<C-i>", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "[Harpoon] Add File" },
            { "<C-h>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "[Harpoon] Open Menu" },
            { "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "[Harpoon] Navigate to File" },
            { "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "[Harpoon] Navigate to File" },
            { "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "[Harpoon] Navigate to File" },
            { "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "[Harpoon] Navigate to File" },
        },
    },

    -- Show pending keybindings
    {
        "folke/which-key.nvim",
        config = function(_, opts)
            require("which-key").setup(opts)
            require("which-key").register({
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>f"] = { name = "[F]ile", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
                ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
                ["<leader>h"] = { name = "[H]unk", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
            })
        end,
    },

    -- Zen-Mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { "<leader>z", "<cmd>lua require('zen-mode').toggle()<cr>", desc = "Toggle [Z]en-Mode" },
        },
        opts = {
            window = {
                width = .395,
            }
       },
    },

    -- Set lualine as statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "catppuccin",
                globalstatus = true,
                icons_enabled = true,
                section_separators = "",
                component_separators = "|",
                extensions = { "fugitive", "nvim-tree", "lazy" },
            },
            sections = {
                lualine_a = { { "mode", icon = "" } },
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
        opts = {
            transparent_background = true,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Add indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        opts = {
            scope = { enabled = false },
        },
    },

    -- Automatically insert closing tags
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
    },


    -- Kitty config file syntax highlighting
    { "fladson/vim-kitty", ft = "kitty" },

    -- Source Code Comments
    "tpope/vim-commentary",

    -- Git Integration
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "shumphrey/fugitive-gitlab.vim",

    -- Git Worktree Operations
    {
        "ThePrimeagen/git-worktree.nvim",
        keys = {
            {
                "<leader>gwl",
                "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
                desc = "Switch [G]it [W]orktree",
            },
            {
                "<leader>gwc",
                "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
                desc = "Create [G]it [W]orktree",
            },
        },
        config = function()
            require("telescope").load_extension("git_worktree")
        end,
    },

    -- Git Decorations
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
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
                        gitsigns.next_hunk()
                    end)
                    return "<Ignore>"
                end, "Next Hunk", true)

                map("[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gitsigns.prev_hunk()
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
                map("<leader>hb", gitsigns.blame_line, "Blame Line")
                map("<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Current Line Blame")
            end,
        },
    },
}, {
    defaults = {
        -- Disable loading plugins inside VSCode by default
        cond = not vim.g.vscode,
    },
})

-- vim: ts=2 sts=4 sw=4 et
