-- [[ Setting options ]]
-- See `:help vim.o`

-- Set <space> as the leader keyinit
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Show relative line numbers
vim.wo.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
-- See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Enable smart indent
vim.opt.smartindent = true

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
vim.wo.signcolumn = 'yes'

-- Set Scrolloff to 8 lines
vim.o.scrolloff = 8

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Enable the use of 24-bit true color
-- NOTE: Make sure the terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Remap <Space> to <Nop> to avoid conflicts with leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Automatically center the cursor when moving up or down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ LSP ]]

-- Language Server Configuration
local servers = {
    gopls = {},
    tsserver = {},
    lua_ls = {
        settings = {
            Lua = {
                workspace = { checkthirdparty = false },
                telemetry = { enable = false },
            }
        },
    }
}

-- Executed when the LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    local builtin = require('telescope.builtin')

    local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Workspace functionality
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Command to format local to the LSP buffer
    nmap('<leader>ff', vim.lsp.buf.format, '[F]ormat current buffer')

    -- Automatically organize imports on save using goimports
    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
            vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
        end
    })
end

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- See `:help lazy.nvim.txt`
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
-- Use the `:Lazy` command to manage
require('lazy').setup({
    -- LSP Configuration & Plugins
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim.
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim', config = true },

            -- Additional lua configuration for Neovim setup and plugin development.
            { 'folke/neodev.nvim', config = true },
        },
        keys = {
            -- Diagnostic keymaps
            { '[d', vim.diagnostic.goto_prev, desc = 'Go to previous diagnostic message' },
            { ']d', vim.diagnostic.goto_next, desc = 'Go to next diagnostic message' },
            { '<leader>e', vim.diagnostic.open_float, desc = 'Open floating diagnostic message' },
            { '<leader>q', vim.diagnostic.setloclist, desc = 'Open diagnostics list' },
        },
        config = function()
            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Setup mason-lspconfig so it can manage external tooling
            local mason_lspconfig = require('mason-lspconfig')

            mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        settings = servers[server_name],
                        apabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
            })
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        opts = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
                experimental = {
                    ghost_text = false,
                },
            }
        end,
    },

    -- GitHub Copilot
    {
        'github/copilot.vim',
        event = 'InsertEnter',
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        keys = {
            { '<C-[>', 'copilot#Accept("")', mode = { 'i', 'n' }, silent = true, expr = true, replace_keycodes = false },
            { '<C-H>', 'copilot#Previous()', mode = 'i', silent = true, expr = true },
            { '<C-K>', 'copilot#Next()', mode = 'i', silent = true, expr = true },
        },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',

            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
                config = function()
                    require('telescope').load_extension('fzf')
                end,
            },
        },
        keys = {
            -- Buffers & Files
            { '<leader>?', '<cmd>Telescope oldfiles<cr>', desc = '[?] Find recently opened files' },
            { '<leader><space>', '<cmd>Telescope buffers show_all_buffers=true<cr>',  desc = '[ ] Find existing buffers' },
            { '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = '[/] Fuzzily search in current buffer' },
            { '<leader>sf', function()
                -- See https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
                vim.fn.system('git rev-parse --is-inside-work-tree')
                if vim.v.shell_error == 0 then
                    require('telescope.builtin').git_files({ recurse_submodules = true })
                else
                    require('telescope.builtin').find_files({ hidden = true })
                end
            end, desc = '[S]earch [F]iles' },
            -- Search
            { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = '[S]earch [H]elp' },
            { '<leader>sw', '<cmd>Telescope grep_string<cr>', desc = '[S]earch [W]ord' },
            { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = '[S]earch by [G]rep' },
            { '<leader>sd', '<cmd>Telescope diagnostics<cr>', desc = '[S]earch [D]iagnostics' },
            -- Git
            { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = '[G]it [C]ommits' },
            { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = '[G]it [B]ranches' },
            { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = '[G]it [S]tatus' },
        },
    },

    -- Telescope File Browser Extension
    {
        'nvim-telescope/telescope-file-browser.nvim',
        keys = {
            { '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>', desc = '[F]ile [B]rowser'  },
        },
        config = function()
            require('telescope').load_extension('file_browser')
        end,
    },

    -- Telescope Project Switcher
    {
        'nvim-telescope/telescope-project.nvim',
        keys = {
            { '<leader>sp', '<cmd>Telescope project display_type=full<cr>', desc = '[S]earch [P]rojects' },
        },
        config = function()
            require('telescope').load_extension('project')
        end
    },

    -- Telescope Integration for GitHub
    {
        'nvim-telescope/telescope-github.nvim',
        keys = {
            { '<leader>gi', '<cmd>Telescope gh issues<cr>', desc = '[G]itHub [I]ssues' },
            { '<leader>gp', '<cmd>Telescope gh pull_request<cr>', desc = '[G]itHub [P]ull Request' },
            { '<leader>gr', '<cmd>Telescope gh run<cr>', desc = '[G]itHub Workflow [R]un' },
        },
        config = function()
            require('telescope').load_extension('gh')
        end,
    },

    -- Highlight, edit, and navigate code using a fast incremental parsing library.
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
             -- Show the local context of the currently visible buffer contents.
            'nvim-treesitter/nvim-treesitter-context',
        },
        opts = {
            ensure_installed = { 'go', 'lua', 'json', 'tsx', 'typescript', 'vimdoc', 'vim', 'yaml' },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
           require('nvim-treesitter.configs').setup(opts)
        end,
    },

    -- Show pending keybindings.
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = true,
    },

    -- Set lualine as statusline
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        opts = {
            options = {
                icons_enabled = false,
                component_separators = '|',
            }
        },
    },

    -- Catppuccin Theme
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function()
            vim.cmd.colorscheme 'catppuccin'
        end,
    },

    -- Add indentation guides
    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            char = "│",
            show_trailing_blankline_indent = false,
            show_current_context = false,
        },
    },

    -- Source Code Comments
    'tpope/vim-commentary',

    -- Add/Change/Delte parentheses/quotes/tags with ease
    'tpope/vim-surround',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- Git Integration
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Git Decorations
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                local gs = require('gitsigns')

                local nmap = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                nmap(']h', gs.next_hunk, 'Next Hunk')
                nmap('[h', gs.prev_hunk, 'Prev Hunk')
                nmap('<leader>hr', gs.reset_hunk, 'Reset Hunk')
                nmap('<leader>hs', gs.stage_hunk, 'Stage Hunk')
                nmap('<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
                nmap('<leader>hS', gs.stage_buffer, 'Stage Buffer')
                nmap('<leader>hU', gs.reset_buffer_index, 'Reset Buffer Index')
                nmap('<leader>hp', gs.preview_hunk_inline, 'Preview Hunk Inline')
                nmap('<leader>hb', gs.blame_line, 'Blame Line')
                nmap('<leader>tb', gs.toggle_current_line_blame, 'Toggle Current Line Blame')
            end,
        },
    },
}, {})

