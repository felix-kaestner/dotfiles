return {
    settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
            -- https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.32.1-standalone-strict/all.json
            schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), { kubernetes = { "k8s**.yaml", "kube*/*.yaml" } }),
            -- disable built-in schema store support to use SchemaStore.nvim
            schemaStore = { enable = false, url = "" },
        },
    },
}
