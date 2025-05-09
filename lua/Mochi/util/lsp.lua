---@class MochiUtil.lsp
local M = {}

---@alias lsp.Client vim.lsp.Client
---@alias lsp.Client.filter { id?: number, bufnr?: number, name?: string, method?: string, filter?: fun(client: lsp.Client ): boolean}

-- get clients filtered by opts
---@param opts? lsp.Client.filter
function M.get_clients(opts)
    local ret = {} ---@type lsp.Client[]

    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
            ---@param client lsp.Client
            ret = vim.tbl_filter(
                function(client) return client.supports_method(opts.method, { bufnr = opts.bufnr }) end,
                ret
            )
        end
    end

    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

-- register events when lsp client attached
---@param on_attach fun(client: lsp.Client, bufnr: number)
---@param name? string
function M.on_attach(on_attach, name)
    return vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local bufnr = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (not name or client.name == name) then return on_attach(client, bufnr) end
        end,
    })
end

-- all methods lsp clients supports
---@type table<string, table<lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.setup()
    local register_capability = vim.lsp.handlers['client/registerCapability']
    vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            for bufnr in pairs(client.attached_buffers) do
                vim.api.nvim_exec_autocmds('User', {
                    pattern = 'LspDynamicCapability',
                    data = {
                        client_id = client.id,
                        bufnr = bufnr,
                    },
                })
            end
        end
        return ret
    end
    M.on_attach(M._check_methods)
    M.on_dynamic_capability(M._check_methods)
end

-- check which methods the lsp client of this buffer support
---@param client lsp.Client
---@param bufnr number
function M._check_methods(client, bufnr)
    -- don't trigger on invalid buffers
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    -- don't trigger on non-listed buffers
    if not vim.bo[bufnr].buflisted then return end

    -- don't trigger on nofile buffers
    if vim.bo[bufnr].buftype == 'nofile' then return end

    for method, clients in pairs(M._supports_method) do
        clients[client] = clients[client] or {}
        if not clients[client][bufnr] then
            if client.supports_method and client.supports_method(method, { bufnr = bufnr }) then
                clients[client][bufnr] = true
                vim.api.nvim_exec_autocmds('User', {
                    pattern = 'LspSupportsMethod',
                    data = {
                        client_id = client.id,
                        bufnr = bufnr,
                        method = method,
                    },
                })
            end
        end
    end
end

-- register dynamic capability event
---@param fn fun(client: lsp.Client, bufnr: number): boolean?
---@param opts? { group?: integer }
function M.on_dynamic_capability(fn, opts)
    return vim.api.nvim_create_autocmd('User', {
        pattern = 'LspDynamicCapability',
        group = opts and opts.group or nil,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.data.bufnr ---@type number
            if client then return fn(client, bufnr) end
        end,
    })
end

-- get capabilities
---@param capabilities table
---@return table
function M.get_capabilities(capabilities)
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        capabilities or {}
    )
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    return capabilities
end

-- register lsp client support method
---@param method string
---@param fn fun(client: lsp.Client, bufnr: number)
function M.on_supports_method(method, fn)
    M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = 'k' })
    return vim.api.nvim_create_autocmd('User', {
        pattern = 'LspSupportsMethod',
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.data.bufnr ---@type number
            if client and method == args.data.method then return fn(client, bufnr) end
        end,
    })
end

-- pop a input box for typing new file name
function M.rename_file()
    local buf = vim.api.nvim_get_current_buf()
    local old = assert(Util.path.realpath(vim.api.nvim_buf_get_name(buf)))
    local root = assert(Util.path.realpath(Util.path.root({ normalize = true })))
    assert(old:find(root, 1, true) == 1, 'File not in project root')

    local extra = old:sub(#root + 2)

    vim.ui.input({
        prompt = 'New File Name: ',
        default = extra,
        completion = 'file',
    }, function(new)
        if not new or new == '' or new == extra then return end

        new = Util.path.norm(root .. '/' .. new)
        vim.fn.mkdir(vim.fs.dirname(new), 'p')
        M.on_rename(old, new, function()
            vim.fn.rename(old, new)
            vim.cmd.edit(new)
            vim.api.nvim_buf_delete(buf, { force = true })
            vim.fn.delete(old)
        end)
    end)
end

---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
    local changes = {
        files = {
            {
                oldUri = vim.uri_from_fname(from),
                newUri = vim.uri_from_fname(to),
            },
        },
    }

    local clients = M.get_clients()
    for _, client in ipairs(clients) do
        if client.supports_method('workspace/willRenameFiles') then
            local resp = client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end
        end
    end

    if rename then rename() end

    for _, client in ipairs(clients) do
        if client.supports_method('workspace/didRenameFiles') then
            client.notify('workspace/didRenameFiles', changes)
        end
    end
end

-- get lsp server config
---@param server string
function M.get_config(server)
    local configs = require('lspconfig.configs')
    return rawget(configs, server)
end

-- check if lsp server is enabled
---@param server string
---@return boolean
function M.is_enabled(server)
    local c = M.get_config(server)
    return c and c.enabled ~= false
end

-- disable lsp server
---@param server string
---@param cond fun(root_dir, config): boolean
function M.disable(server, cond)
    local util = require('lspconfig.util')
    local def = M.get_config(server)
    def.document_config.on_new_config = util.add_hook_before(
        def.document_config.on_new_config,
        function(config, root_dir)
            if cond(root_dir, config) then config.enabled = false end
        end
    )
end

-- get formatters provided by lsp
---@param opts? MochiFormatter | { filter?: (string | lsp.Client.filter) }
function M.formatter(opts)
    opts = opts or {}
    local filter = opts.filter or {}
    filter = type(filter) == 'string' and { name = filter } or filter
    ---@cast filter lsp.Client.filter

    ---@type MochiFormatter
    local ret = {
        name = 'LSP',
        primary = true,
        priority = 1,
        format = function(buf) M.format(Util.merge({}, filter, { bufnr = buf })) end,
        sources = function(buf)
            local clients = M.get_clients(Util.merge({}, filter, { bufnr = buf }))

            ---@param client lsp.Client
            local ret = vim.tbl_filter(
                function(client)
                    return client.supports_method('textDocument/formatting')
                        or client.supports_method('textDocument/rangeFormatting')
                end,
                clients
            )

            ---@param client lsp.Client
            return vim.tbl_map(function(client) return client.name end, ret)
        end,
    }

    return Util.merge(ret, opts) --[[@as MochiFormatter]]
end

---@alias lsp.Client.format { timeout: number, format_options?: table } | lsp.Client.filter

---@param opts? lsp.Client.format
function M.format(opts)
    opts = vim.tbl_deep_extend(
        'force',
        {},
        opts or {},
        Util.plugin.opts('nvim-lspconfig').format or {},
        Util.plugin.opts('conform.nvim').format or {}
    )

    local ok, conform = pcall(require, 'conform')
    if ok then
        opts.formatters = {}
        conform.format(opts)
    else
        vim.lsp.buf.format(opts)
    end
end

-- check if the lsp clients of this buffer support some specific methods
---@param bufnr? number
---@param method string | string[]
---@return boolean
function M.support(bufnr, method)
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr

    if type(method) == 'table' then
        for _, m in ipairs(method) do
            if M.support(bufnr, m) then return true end
        end
        return false
    end

    method = method:find('/') and method or 'textDocument/' .. method
    local clients = M.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then return true end
    end

    return false
end

---@alias LspWord { from: { [1]: number, [2]: number }, to: { [1]: number, [2]: number } } 1-0 indexed
M.words = {}
M.words.enabled = false
M.words.ns = vim.api.nvim_create_namespace('vim_lsp_references')

---@param opts? { enabled?: boolean }
function M.words.setup(opts)
    opts = opts or {}
    if not opts.enabled then return end

    M.words.enabled = true

    local handler = vim.lsp.handlers['txetDocument/documentHighlight']
    vim.lsp.handlers['txetDocument/documentHighlight'] = function(err, result, ctx, config)
        if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then return end

        vim.lsp.buf.clear_references()
        return handler(err, result, ctx, config)
    end

    M.on_supports_method('textDocument/documentHighlight', function(_, buf)
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' }, {
            group = vim.api.nvim_create_augroup('lsp_word_' .. buf, { clear = true }),
            buffer = buf,
            callback = function(ev)
                if not M.support(buf, 'documentHighlight') then return false end

                if not ({ M.words.get() })[2] then
                    if ev.event:find('CursorMoved') then
                        vim.lsp.buf.clear_references()
                    elseif not Util.cmp.visible() then
                        vim.lsp.buf.document_highlight()
                    end
                end
            end,
        })
    end)

    -- setup hl
    vim.schedule(function()
        -- vim.api.nvim_set_hl(0, 'LspReferenceText', { bold = true, underline = true })
        vim.api.nvim_set_hl(0, 'LspReferenceRead', { bold = true, underline = true })
        vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bold = true, underline = true })
    end)
end

---@return LspWord[] words, number? current
function M.words.get()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current, ret = nil, {} ---@type number?, LspWord[]
    for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, M.words.ns, 0, -1, { details = true })) do
        local w = {
            from = { extmark[2] + 1, extmark[3] },
            to = { extmark[4].end_row + 1, extmark[4].end_col },
        }
        ret[#ret + 1] = w
        if cursor[1] >= w.from[1] and cursor[1] <= w.to[1] and cursor[2] >= w.from[2] and cursor[2] <= w.to[2] then
            current = #ret
        end
    end

    return ret, current
end

---@param count number
---@param cycle? boolean
function M.words.jump(count, cycle)
    local words, idx = M.words.get()
    if not idx then return end

    idx = idx + count
    if cycle then idx = (idx - 1) % #words + 1 end

    local target = words[idx]
    if target then vim.api.nvim_win_set_cursor(0, target.from) end
end

M.action = setmetatable({}, {
    __index = function(_, action)
        return function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { action },
                    diagnostics = {},
                },
            })
        end
    end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
    local params = {
        command = opts.command,
        arguments = opts.arguments,
    }

    if opts.open then
        require('trouble').open({
            mode = 'lsp_command',
            params = params,
        })
    else
        return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
    end
end

return M
