local M = {
    settings = {
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
                ST1001 = false, -- https://staticcheck.dev/docs/checks#ST1001
            },
            codelenses = {
                test = true,
                gc_details = true,
            },
            hints = {
                constantValues = true,
            },
        },
    },
}

if vim.fn.executable("go") == 1 then
    local Job = require("plenary.job")
    Job:new({
        command = "go",
        args = { "list", "-m", "-f", "'{{.Path}}'" },
        on_exit = function(job, code)
            if code ~= 0 then
                return
            end

            -- See: https://github.com/golang/tools/blob/master/gopls/doc/settings.md#local-string
            local module = table.concat(job:result()):gsub("'", "")
            if module == "command-line-arguments" then
                return
            end

            M.settings.gopls["local"] = module
        end,
    }):sync()
end

return M
