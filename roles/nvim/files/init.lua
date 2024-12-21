-- [[ Settings ]]
require("config.options")
require("config.keymaps")
require("config.autocmds")

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
require("lazy").setup({ import = "plugins" }, {
    change_detection = {
        notify = false,
    },
})
