local M = {}

---@class MochiKeyOpts.extra.lsp : MochiKeyOpts
---@field has_method? string | string[]
---@field cond? fun(): boolean

M.key = {}

-- stylua: ignore
function M.key.keys()
    return {
        { 'n', 'ga',        require('clear-action.actions').code_action, 'Code Actions' },
        { 'n', '<leader>i', function() Util.format() end,                'Format', icon = '󰉢' },
        { 'n', 'gd',        vim.lsp.buf.definition,                      'Goto Definition',    has_method = 'definition' },
        { 'n', 'gh',        vim.lsp.buf.hover,                           'Hover' },
        { 'n', 'gD',        vim.lsp.buf.declaration,                     'Goto Declaration' },
        { 'n', 'gI',        vim.lsp.buf.implementation,                  'Goto Implementation' },
        { 'n', 'gr',        vim.lsp.buf.references,                      'List References',    nowait = true },
        { 'n', 'gH',        vim.lsp.buf.signature_help,                  'Signature Help',     has_method = 'signatureHelp' },
        { 'i', '<C-k>',     vim.lsp.buf.signature_help,                  'Signature Help',     has_method = 'signatureHelp' },
        { 'n', 'gR',        Util.lsp.rename_file,                        'Rename File',        has_method = { 'workspace/willRenameFiles', 'workspace/didRenameFiles' } },
        {
            'n', 'gr',
            function()
                local inc_rename = require('inc_rename')
                return ':' .. inc_rename.config.cmd_name .. ' ' .. vim.fn.expand('<cword>')
            end,
            'Rename',
            has_method = 'rename',
            expr = true
        },
        {
            'n', 'g[',
            function() Util.lsp.words.jump(-vim.v.count1, true) end,
            'Prev Reference',
            has_method = 'documentHighlight',
            cond = function() return Util.lsp.words.enabled end
        },
        {
            'n', 'g]',
            function() Util.lsp.words.jump(vim.v.count1, true) end,
            'Next Reference',
            has_method = 'documentHighlight',
            cond = function() return Util.lsp.words.enabled end
        },
    }
end

---@param bufnr? number
---@param method string | string[]
function M.key.has_method(bufnr, method)
    if type(method) == 'table' then
        for _, m in ipairs(method) do
            if M.key.has_method(bufnr, m) then return true end
        end
        return false
    end

    method = method:find('/') and method or 'textDocument/' .. method
    bufnr = bufnr or 0
    local clients = Util.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then return true end
    end
    return false
end

local function parse_key(key)
    key = key or {}
    local mode = table.remove(key, 1)
    local lhs = table.remove(key, 1)
    local rhs = table.remove(key, 1)
    local desc = table.remove(key, 1)
    return {
        mode = mode,
        lhs = lhs,
        rhs = rhs,
        desc = desc,
        opts = key,
    }
end

M.key.attach = function(bufnr)
    Util.keymap.key_group('g', '+ LSP actions')

    for _, key in ipairs(M.key.keys()) do
        key = parse_key(key)
        local opts = vim.tbl_extend('force', {
            noremap = true,
            silent = true,
        }, key.opts)
        opts.buffer = bufnr

        local has_method = not opts.has_method or M.key.has_method(bufnr, opts.has_method)
        local cond = not (opts.cond == false or ((type(opts.cond) == 'function') and not opts.cond()))

        if has_method and cond then
            opts.has_method = nil
            opts.cond = nil
            Util.keymap(key.mode, key.lhs, key.rhs, opts, key.desc)
        end
    end
end

M.navic = {}
M.navic.attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then require('nvim-navic').attach(client, bufnr) end
end

M.on_attach = function(client, bufnr) M.navic.attach(client, bufnr) end

M.flags = {
    debounce_text_changes = 150,
}

return M
