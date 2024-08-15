local common = require("lsp.common-config")

-- return {
--     on_setup = function(server)
--         server.setup({
--             capabilities = common.capabilities,
--             flags = common.flags,
--             on_attach = function(client, bufnr)
--                 common.keyAttach(bufnr)
--                 common.disableFormat(client)
--                 common.setupNavic(client, bufnr)
--                 require('completion').on_attach(client)
--             end,
--             settings = {
--                 ["rust-analyzer"] = {
--                     imports = {
--                         granularity = {
--                             group = "module",
--                         },
--                         prefix = "self",
--                     },
--                     cargo = {
--                         buildScripts = {
--                             enable = true,
--                         },
--                     },
--                     procMacro = {
--                         enable = true
--                     },
--                 }
--             },
--         })
--     end,
-- }

vim.g.rustaceanvim = {
    tools = {},
    server = {
        on_attach = function(client, bufnr)
            -- keybindings.Map('n', '<leader>a', function() vim.cmd.RustLsp('codeAction') end, { silent = true, buffer = bufnr }, 'code actions')
            common.on_attach(client, bufnr)
        end,
        default_settings = {
            ['rust-analyzer'] = {},
        }
    },
    dap = {},
}