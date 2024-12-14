-- [[ Setting options ]]
-- See `:help vim.o`

-- Set <space> as the leader keyinit
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set highlight on search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- See `:help 'clipboard'`
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Disable line wrapping
vim.wo.wrap = false

-- Save undo history
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Enable spell checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Preview substitutions live
vim.opt.inccommand = "split"

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

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

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Open/Close Terminal
vim.keymap.set("n", "<leader>t", function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
            vim.api.nvim_set_current_win(win)
            vim.cmd("startinsert")
            return
        end
    end

    vim.cmd("botright terminal")
    vim.cmd("startinsert")
end)

-- Open/Close Quicklist
vim.keymap.set("n", "<leader>co", function()
    if vim.fn.getqflist({ winid = 0 }).winid == 0 then
        vim.cmd.copen()
    else
        vim.cmd.cclose()
    end
end)

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
vim.keymap.set("n", "<C-S>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[S]earch & [R]eplace" })

-- Shorthand to insert \(.*\) in command mode
vim.keymap.set("c", "<F1>", [[\(.*\)]], { noremap = true, silent = true })

-- Convert from one case to another
vim.keymap.set("v", "<leader>crc", [[:s/\%V_\([a-zA-Z]\)/\u\1/g]], { desc = "[C]onvert to [C]amel Case" })
vim.keymap.set("v", "<leader>crs", [[:s/\%V[a-z]\@<=[A-Z]/_\l\0/g]], { desc = "[C]onvert to [S]nake Case" })

-- Shorthand to launch Git pane
vim.keymap.set("n", "<leader>gp", "<cmd>0Git<cr>", { desc = "[G]it [P]ane" })

-- Shorthand to launch Netrw
vim.keymap.set("n", "-", vim.cmd.Ex, { desc = "File Explorer" })

-- [[ Folds ]]
vim.opt.foldlevel = 16
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- [[ Netrw ]]
vim.g.netrw_altv = 1 -- Split right
vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_localcopydircmd = "cp -r" -- Enable recursive copy of directories.

-- Based on "tpope/vim-vinegar"
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    group = vim.api.nvim_create_augroup("netrw-enhanced", { clear = true }),
    callback = function()
        vim.keymap.set("n", ".", function()
            local path = vim.b.netrw_curdir .. "/" .. vim.fn.expand("<cfile>")
            local cmd = ":<C-U> " .. vim.fn.fnameescape(path) .. "<Home>"
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), "n", true)
        end, { buffer = true })

        vim.keymap.set("n", "y.", function()
            local path = vim.b.netrw_curdir .. "/" .. vim.fn.expand("<cfile>")
            vim.fn.setreg(vim.v.register, path)
        end, { buffer = true, silent = true })
    end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

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
            codelenses = {
                test = true,
                gc_details = true,
            },
            hints = {
                constantValues = true,
            },
            buildFlags = { "-tags=test" },
        },
    },

    golangci_lint_ls = {},

    rust_analyzer = {},

    jsonls = {
        json = {
            ---@module 'schemastore'
            ---@type SchemaOpts?
            schemas = nil,
            validate = { enable = true },
        },
    },

    lua_ls = {
        Lua = {
            format = { enable = false },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
        },
    },

    pyright = {},

    terraformls = {
        experimentalFeatures = {
            validateOnSave = true,
            prefillRequiredFields = true,
        },
    },

    ts_ls = {},

    yamlls = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
            ---@module 'schemastore'
            ---@type SchemaOpts?
            schemas = nil,
            -- disable built-in schema store support to use SchemaStore.nvim
            schemaStore = { enable = false, url = "" },
        },
    },
}

-- Executed when the LSP connects to a particular buffer
---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
    local builtin = require("telescope.builtin")

    local map = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, nowait = true })
    end

    map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gr", builtin.lsp_references, "[G]oto [R]eferences")
    map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    -- stylua: ignore
    map("gR", function() builtin.lsp_references({ file_ignore_patterns = { "%_test.go", "%_gen.go", "%.pb.go" } }) end, "[G]oto [R]eferences w/o Test & Generated Files")
    map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]enses")

    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("<leader>cc", function()
        vim.lsp.buf.code_action({
            apply = true,
            filter = function(act)
                return act.isPreferred
            end,
        })
    end, "Apply [C]ode Action")

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

        map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, "T]oggle Inlay [H]ints")
    end

    -- Automatically format source code on save
    if client:supports_method("textDocument/formatting", bufnr) and client.name ~= "tsserver" then
        local augroup = vim.api.nvim_create_augroup("lsp-format", { clear = true })
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                if client.name == "gopls" then
                    -- Organize imports using the LSP
                    -- See: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
                    ---@diagnostic disable-next-line: missing-parameter
                    local params = vim.lsp.util.make_range_params()
                    params["context"] = { only = { "source.organizeImports" } }
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

-- Install plugin manager
-- See `:help lazy.nvim` or https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local stdout = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Failed to clone lazy.nvim:\n" .. stdout)
    end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
-- Use the `:Lazy` command to manage
require("lazy").setup({
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- Automatically install LSPs to stdpath
            { "williamboman/mason.nvim", cmd = { "Mason", "MasonUpdate" }, build = ":MasonUpdate", opts = {} },
            "williamboman/mason-lspconfig.nvim",

            -- SchemaStore catalog for jsonls and yamlls
            "b0o/schemastore.nvim",
        },
        config = function()
            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Setup mason-lspconfig so it can manage external tooling
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),

                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            settings = servers[server_name],
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["gopls"] = function()
                        local settings = servers.gopls

                        local Job = require("plenary.job")

                        if vim.fn.executable("go") == 1 then
                            Job:new({
                                command = "go",
                                args = { "list", "-m", "-f", "'{{.Path}}'" },
                                on_exit = function(job, code)
                                    if code ~= 0 then
                                        return
                                    end

                                    -- See: https://github.com/golang/tools/blob/master/gopls/doc/settings.md#local-string
                                    local module = table.concat(job:result()):gsub("'", "")
                                    settings.gopls["local"] = module

                                    if string.find(module, "aboutyou.com") then
                                        settings.gopls.analyses.deprecated = false
                                        settings.gopls.analyses.fieldalignment = false
                                        settings.gopls.analyses.unusedparams = false
                                    end
                                end,
                            }):sync()
                        end

                        require("lspconfig").gopls.setup({
                            settings = settings,
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })

                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            group = vim.api.nvim_create_augroup("lsp-codelens", {}),
                            pattern = { "*.go", "*.mod" },
                            callback = function()
                                if #vim.lsp.get_clients({ bufnr = 0, name = "gopls" }) > 0 then
                                    vim.lsp.codelens.refresh({ bufnr = 0 })
                                end
                            end,
                        })
                    end,

                    ["jsonls"] = function()
                        local settings = servers.jsonls

                        settings.json.schemas = require("schemastore").json.schemas(settings.json.schemas)

                        require("lspconfig").jsonls.setup({
                            settings = settings,
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["yamlls"] = function()
                        local settings = servers.yamlls

                        settings.yaml.schemas = require("schemastore").yaml.schemas(settings.yaml.schemas)

                        require("lspconfig").yamlls.setup({
                            settings = settings,
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,
                },
            })
        end,
        keys = {
            { "<leader>q", vim.diagnostic.setloclist, desc = "Open buffer diagnostics list" },
            { "<leader>Q", vim.diagnostic.setqflist, desc = "Open diagnostics list" },
        },
    },

    -- Useful status updates for LSP
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },

    -- Additional LuaLS configuration for Neovim config and plugin development
    {
        "folke/lazydev.nvim",
        ft = "lua",
        ---@module 'lazydev'
        ---@type lazydev.Config
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

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
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "saadparwaiz1/cmp_luasnip",
            {
                -- Set of preconfigured snippets for different languages
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "go" } })
                    -- stylua: ignore
                    require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets/" })
                end,
            },
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            ---@module 'cmp'
            ---@type cmp.ConfigSchema
            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                ---@diagnostic disable-next-line: missing-fields
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
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping(function(fallback)
                        if not cmp.visible() then
                            cmp.complete()
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
                    {
                        name = "lazydev",
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    },
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

    -- Automatically insert closing tags
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        enabled = false,
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
        main = "nvim-treesitter.configs",
        priority = 1000,
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
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        -- stylua: ignore
        keys = {
            { "<leader>re", "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", desc = "[R]efactor" },
            { "<leader>ri", "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", desc = "[R]efactor [I]nline Variable" },
        },
        config = function()
            require("telescope").load_extension("refactoring")
        end,
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

            "nvim-telescope/telescope-ui-select.nvim",
        },
        opts = function()
            return {
                defaults = require("telescope.themes").get_ivy({
                    layout_config = {
                        height = math.floor(vim.o.lines * 0.5),
                    },
                }),
                extensions = {
                    ["fzf"] = {},
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")

            telescope.setup(opts)
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
        -- stylua: ignore
        keys = {
            -- Buffers & Files
            { "<leader>.", "<cmd>Telescope oldfiles<cr>", desc = "[?] Find recently opened files" },
            { "<leader><leader>", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "[ ] Find existing buffers" },
            { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
            -- Edit
            { "<leader>sn", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", desc = "[S]earch [N]eovim Config Files" },
            { "<leader>sp", "<cmd>Telescope find_files cwd=~/.local/share/nvim/lazy<cr>", desc = "[S]earch Neovim [P]lugin Files" },
            -- Search
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
            { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch [W]ord" },
            { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
            { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
            { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
            { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect" },
            { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[/] Fuzzily search in current buffer" },
            -- Git
            { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Search [G]it [F]iles" },
            { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "[G]it [C]ommits" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "[G]it [B]ranches" },
            { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "[G]it [S]tatus" },
        },
    },

    -- Telescope Integration for GitHub
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

    -- Quick Navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        ---@module 'harpoon'
        ---@type HarpoonPartialConfig
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            require("harpoon"):setup(opts)
            require("telescope").load_extension("harpoon")
        end,
        -- stylua: ignore
        keys = {
            { "<C-m>", "<cmd>lua require('harpoon'):list():add()<cr>", desc = "[Harpoon] [M]ark File" },
            { "<C-h>", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>", desc = "[Harpoon] Open Menu" },
            { "<A-d>", "<cmd>lua require('harpoon'):list():prev({ ui_nav_wrap = true })<cr>", desc = "[Harpoon] Navigate Previous" },
            { "<A-f>", "<cmd>lua require('harpoon'):list():next({ ui_nav_wrap = true })<cr>", desc = "[Harpoon] Navigate Next" },
            { "<leader>1", "<cmd>lua require('harpoon'):list():select(1)<cr>", desc = "[Harpoon] Navigate to File 1" },
            { "<leader>2", "<cmd>lua require('harpoon'):list():select(2)<cr>", desc = "[Harpoon] Navigate to File 2" },
            { "<leader>3", "<cmd>lua require('harpoon'):list():select(3)<cr>", desc = "[Harpoon] Navigate to File 3" },
            { "<leader>4", "<cmd>lua require('harpoon'):list():select(4)<cr>", desc = "[Harpoon] Navigate to File 4" },
        },
    },

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
                { "<leader>r", group = "[R]ename" },
                { "<leader>s", group = "[S]earch" },
                { "<leader>t", group = "[T]test" },
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
            plugins = {
                gitsigns = { enabled = true }, -- disables git signs
            },
        },
        keys = {
            { "<leader>z", "<cmd>lua require('zen-mode').toggle()<cr>", desc = "Toggle [Z]en-Mode" },
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
                extensions = {
                    "fugitive",
                    "lazy",
                    "man",
                    "mason",
                    "nvim-dap-ui",
                    "quickfix",
                },
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
        ---@module 'catppuccin'
        ---@type CatppuccinOptions
        opts = {
            integrations = {
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
            vim.cmd.colorscheme("catppuccin")
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

    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function(_, opts)
                    local dap, dapui = require("dap"), require("dapui")
                    dapui.setup(opts)
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
            -- stylua: ignore
            { "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Debug: Breakpoint Condition" },
        },
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            delve = {
                build_flags = "-tags=test",
            },
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

    -- Line and column number support
    "wsdjeg/vim-fetch",

    -- Git Integration
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "shumphrey/fugitive-gitlab.vim",

    -- Git Worktree Operations
    {
        "ThePrimeagen/git-worktree.nvim",
        config = function()
            require("telescope").load_extension("git_worktree")

            local Worktree = require("git-worktree")

            Worktree.on_tree_change(function(op, metadata)
                if op == Worktree.Operations.Create then
                    -- Copy required environment variables for project setup
                    -- stylua: ignore
                    vim.fn.system("cp " .. Worktree.get_root() .. "/.env*" .. " " .. Worktree.get_worktree_path(metadata.path) .. "/")
                end
            end)

            -- Update the working directory of the current tmux session when switching between worktrees
            if os.getenv("TMUX") ~= nil then
                Worktree.on_tree_change(function(op, metadata)
                    if op == Worktree.Operations.Switch then
                        vim.fn.system("tmux attach-session -t . -c " .. Worktree.get_worktree_path(metadata.path))
                    end
                end)
            end
        end,
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
    },

    -- Git Diff View
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>lua require('diffview').open()<cr>", desc = "[G]it [D]iff" },
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
                map("<leader>hb", gitsigns.blame_line, "Blame Line")
                map("<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Current Line Blame")
            end,
        },
    },
})

-- vim: ts=2 sts=4 sw=4 et
