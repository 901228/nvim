local M = {}

---@class MochiKeyOpts.extra.lsp : MochiKeyOpts
---@field has_method? string | string[]
---@field cond? fun(): boolean

---@alias MochiLspKeySpec MochiKeySpec | MochiKeyOpts.extra.lsp
---@alias MochiLspKey MochiKey | MochiKeyOpts.extra.lsp
---@alias MochiLspKeyGroupSpec MochiKeyGroupSpec | MochiKeyOpts.extra.lsp
---@alias MochiLspKeyGroup MochiKeyGroup | MochiKeyOpts.extra.lsp

M.key = {}

---@type (MochiLspKeyGroupSpec | MochiLspKeySpec)[]
M.key.keys = {
    {
        'g', '+ LSP actions',
        {
            { 'n', 'a', require('clear-action.actions').code_action, 'Code Actions' },
            { 'n', 'd', vim.lsp.buf.definition, 'Goto Definition', has_method = 'definition' },
            { 'n', 'h', vim.lsp.buf.hover, 'Hover' },
            { 'n', 'D', vim.lsp.buf.declaration, 'Goto Declaration' },
            { 'n', 'I', vim.lsp.buf.implementation, 'Goto Implementation' },
            { 'n', 'r', vim.lsp.buf.references, 'List References', nowait = true },
            { 'n', 'H', vim.lsp.buf.signature_help, 'Signature Help', has_method = 'signatureHelp' },
            { 'i', '<C-k>', vim.lsp.buf.signature_help, 'Signature Help', has_method = 'signatureHelp' },
            { 'n', 'r', '<CMD>IncRename ' .. vim.fn.expand('<cword>') .. '<CR>', 'Rename', expr = true, has_method = 'rename' },
            { 'n', 'R', Util.lsp.rename_file, 'Rename File', has_method = { 'workspace/willRenameFiles', 'workspace/didRenameFiles' } },
            { 'n', '[', function() Util.lsp.words.jump(-vim.v.count1, true) end, 'Prev Reference', has_method = 'documentHighlight', cond = function() return Util.lsp.words.enabled end },
            { 'n', ']', function() Util.lsp.words.jump(vim.v.count1, true) end, 'Next Reference', has_method = 'documentHighlight', cond = function() return Util.lsp.words.enabled end },
        },
    },
}

---@param keys? (MochiLspKeyGroup | MochiLspKey)[]
---@param bufnr? number
function M.resolve(keys, bufnr)
    keys = keys or {}

    for _, key in ipairs(keys) do
        ---@type MochiKeyOpts.extra.lsp
        local opts = vim.tbl_extend('force',
            {
                noremap = true,
                silent = true,
            },
            key.opts,
            { buffer = bufnr }
        )
        local has_method = not opts.has_method or M.key.has_method(bufnr, opts.has_method)
        local cond = not (opts.cond == false or ((type(opts.cond) == 'function') and not opts.cond()))

        ---@diagnostic disable-next-line
        if Util.keymap.is_group(key) then
            ---@cast key MochiKeyGroup
            if has_method and cond then
                opts.has_method = nil
                opts.cond = nil
                Util.keymap.key_group(key.lhs, key.name, opts)
                M.resolve(key.keys, bufnr)
            end
        else
            ---@cast key MochiKey

            if has_method and cond then
                opts.has_method = nil
                opts.cond = nil
                Util.keymap.keymap(key.mode, key.lhs, key.rhs, opts, key.desc)
            end
        end
    end
end

---@param bufnr? number
---@param method string | string[]
function M.key.has_method(bufnr, method)
    if type(method) == 'table' then
        for _, m in ipairs(method) do
            if M.key.has_method(bufnr, m) then
                return true
            end
        end
        return false
    end

    method = method:find('/') and method or 'textDocument/' .. method
    bufnr = bufnr or 0
    local clients = Util.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

M.key.attach = function(bufnr)
    local keys = Util.keymap.parse(vim.deepcopy(M.key.keys))
    M.resolve(keys, bufnr)
end

M.navic = {}
M.navic.attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
    end
end

M.on_attach = function(client, bufnr)
    M.navic.attach(client, bufnr)
end

M.flags = {
    debounce_text_changes = 150,
}

return M
