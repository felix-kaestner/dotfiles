local kubernetes = "kubernetes"
local file = vim.fn.expand("~/.cache/k8s-schemas/all.json")
if vim.fn.filereadable(file) == 1 then
    kubernetes = file
end

return {
    settings = {
        ["helm-ls"] = {
            yamlls = {
                config = {
                    schemas = {
                        [kubernetes] = "templates/**",
                    },
                },
            },
        },
    },
}
