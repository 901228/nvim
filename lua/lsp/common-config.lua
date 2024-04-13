local M = {}

local navic = require("nvim-navic")

M.keyAttach = function(bufnr)
    -- local function buf_set_keymap(mode, lhs, rhs)
    --   vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
    -- end
    -- bind keybindings
    require("keybindings").mapLSP(bufnr)
end

-- disable formatiing by lsp server, let other plugins to do it
M.disableFormat = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

-- link with navic
M.setupNavic = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

M.on_attach = function(client, bufnr)
    M.keyAttach(bufnr)
    M.disableFormat(client)
    M.setupNavic(client, bufnr)
end

-- M.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.flags = {
    debounce_text_changes = 150,
}

M.default_setting = {
    on_setup = function(server)
        server.setup({
            capabilities = M.capabilities,
            flags = M.flags,
            on_attach = M.on_attach,
        })
    end,
}

return M
