local common = require("lsp.common-config")
local opts = {
    capabilities = common.capabilities,
    flags = common.flags,
    on_attach = common.on_attach,
    single_file_support = true,
}

return {
    on_setup = function(server)
        server.setup(opts)
    end,
}
