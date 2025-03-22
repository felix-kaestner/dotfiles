-- [[ Setting options ]]
-- See `:help vim.o`

-- Set <space> as the leader keyinit
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set highlight on search
vim.opt.hlsearch = true
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

-- Configure how certain whitespace characters are displayed
--  See `:help 'list'` and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Enable spell checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Preview substitutions live
vim.opt.inccommand = "split"

-- [[ Folds ]]
vim.opt.foldlevel = 16
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- [[ Netrw ]]
vim.g.netrw_altv = 1 -- Split right
vim.g.netrw_localcopydircmd = "cp -r" -- Enable recursive copy of directories.

-- See: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
-- Recently https://github.com/neovim/neovim/pull/31074 added support for defining
-- vim.opt.winborder = "single" to set the default border for all floating windows.
-- However setting this option doesn't play nice with telescope, so we stick with this.
local fn = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    return fn(contents, syntax, opts, ...)
end

vim.api.nvim_create_user_command("Script", function(opts)
    local path = vim.fn.expand("~/.local/bin/" .. opts.args)
    vim.fn.writefile({ "#!/usr/bin/env bash" }, path)
    vim.fn.setfperm(path, "rwxr-xr-x")
    vim.cmd("edit " .. path)
end, { nargs = 1 })
