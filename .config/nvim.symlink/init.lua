-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim.
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration for Neovim setup and plugin development.
            'folke/neodev.nvim'
        },
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
    },

    -- GitHub Copilot
    'github/copilot.vim',

    -- Fuzzy Finder (files, lsp, etc)
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' } },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            -- Only load if `make` is available
            return vim.fn.executable 'make' == 1
        end,
        config = function()
            -- Enable telescope fzf native
            pcall(require('telescope').load_extension, 'fzf')
        end,
    },

    -- Telescope File Browser Extension
    {
        'nvim-telescope/telescope-file-browser.nvim',
        config = function()
            -- Enable file browser
            pcall(require('telescope').load_extension, 'file_browser')
        end
    },

    -- Telescope Project Switcher
    {
        'nvim-telescope/telescope-project.nvim',
        config = function()
            -- Enable project switcher
            pcall(require('telescope').load_extension, 'project')
        end
    },

    -- Telescope Integration for GitHub
    {
        'nvim-telescope/telescope-github.nvim',
        config = function()
            -- Enable github integration
            pcall(require('telescope').load_extension, 'gh')
        end
    },

    -- Highlight, edit, and navigate code using a fast incremental parsing library.
    { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" },

    -- Show the local context of the currently visible buffer contents.
    'nvim-treesitter/nvim-treesitter-context',

    -- Show pending keybindings.
    { 'folke/which-key.nvim', opts = {} },

    -- Set lualine as statusline
    { 'nvim-lualine/lualine.nvim', opts = { options = { icons_enabled = false } } },

    -- Catppuccin Theme
    { 'catppuccin/nvim', name = 'catppuccin', config = function() vim.cmd.colorscheme 'catppuccin-mocha' end },

    -- Add indentation guides.
    { 'lukas-reineke/indent-blankline.nvim', opts = { show_trailing_blankline_indent = false } },

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
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            }
        }
    },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

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
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

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

-- [[ Configure Telescope ]]
-- See `:help telescope`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer'  })

vim.keymap.set('n', '<leader>sf', function()
    -- See https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
    vim.fn.system('git rev-parse --is-inside-work-tree')
    if vim.v.shell_error == 0 then
        require('telescope.builtin').git_files({ recurse_submodules = true })
    else
        require('telescope.builtin').find_files({ hidden = true })
    end
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[G]it [S]tatus' })

vim.keymap.set('n', '<leader>gi', require('telescope').extensions.gh.issues, { desc = '[G]itHub [I]ssues' })
vim.keymap.set('n', '<leader>gp', require('telescope').extensions.gh.pull_request, { desc = '[G]itHub [P]ull Request' })
vim.keymap.set('n', '<leader>gr', require('telescope').extensions.gh.run, { desc = '[G]itHub Workflow [R]un' })

vim.keymap.set('n', '<leader>fb', function()
    require('telescope').extensions.file_browser.file_browser({
        path = '%:p:h',
        select_buffer = true,
    })
end, { desc = '[F]ile [B]rowser'  })

vim.keymap.set('n', '<leader>sp', function()
    require('telescope').extensions.project.project({
        display_type = 'full'
    })
end, { desc = '[S]earch [P]rojects' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup({
    ensure_installed = { 'go', 'lua', 'tsx', 'typescript', 'vimdoc', 'vim' },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- GitHub Copilot
-- See `:help copilot`
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

vim.keymap.set('i', '<C-[>', 'copilot#Accept("")', { silent = true, expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-H>', 'copilot#Previous()', { silent = true, expr = true })
vim.keymap.set('i', '<C-K>', 'copilot#Next()', { silent = true, expr = true })

-- [[ LSP ]]

-- Language Server Configuration
local servers = {
    gopls = {},
    tsserver = {},
    lua_ls = {
        Lua = {
            workspace = { checkthirdparty = false },
            telemetry = { enable = false },
        }
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

    -- Wokspace functionality
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

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup neovim lua configuration
require('neodev').setup()

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

-- Setup nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

luasnip.config.setup()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-[>'] = cmp.mapping(function()
            vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
        end),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            local copilot_keys = vim.fn['copilot#Accept']()
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif copilot_keys ~= '' then
                vim.api.nvim_feedkeys(copilot_keys, 'i', true)
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
        ghost_text = true,
    },
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
