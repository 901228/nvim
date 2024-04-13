local common = require("lsp.common-config")
local opts = {
    capabilities = common.capabilities,
    flags = common.flags,
    -- use fixjson to format
    -- https://github.com/rhysd/fixjson
    on_attach = common.on_attach,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}

return {
    on_setup = function(server)
        server.setup(opts)
    end,
}
