local M = {}

local navic = require('nvim-navic')

M.keyAttach = require('keybindings').mapLSP

-- link with navic
M.setupNavic = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

M.on_attach = function(client, bufnr)
    M.keyAttach(bufnr)
    M.setupNavic(client, bufnr)
end

M.flags = {
    debounce_text_changes = 150,
}

return M
