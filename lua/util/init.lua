---@class MochiUtil
---@field plugin MochiUtil.plugin
---@field path MochiUtil.path
---@field ui MochiUtil.ui
---@field diagnostic MochiUtil.diagnostic
---@field format MochiUtil.format
---@field lsp MochiUtil.lsp
---@field cmp MochiUtil.cmp
---@field keymap MochiUtil.keymap
local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require('util.' .. k)
        return t[k]
    end,
})

function M.setup()
    Util.format.setup()
end

M.did_init = false
function M.init()
    if M.did_init then
        return
    end
    M.did_init = true

    Util.plugin.setup()
end

M.colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    lighterGrey  = '#c6c6c6',
    white = '#ffffff',
    red    = '#ff5189',
    pink = '#d4bfff',
    violet = '#ee82ee',
    grey   = '#303030',
    lightBlue = '#59c2ff',
    transparent = nil,
    lightGrey = '#797979',
    yellow = '#FFFF00',
    green = '#bbe67e',
    coral = '#f07178',
    darkGrey = '#242b38',
}

---@param tbl table
function M.find_item(tbl, a0)
    for i, v in pairs(tbl) do
        if type(a0) == 'function' then
            if a0(v) then
                return i
            end
        else
            if v == a0 then
                return i
            end
        end
    end

    return nil
end

M.os = {}

---@return boolean
function M.os.is_win()
    return vim.fn.has("win32") == 1
end

---@return boolean
function M.os.is_linux()
    return vim.fn.has("win32") == 0
end

---@return boolean
function M.os.is_mac()
    --TODO: add mac detect functions
    return false
end

M.is_version_10 = (tonumber(vim.version().minor) >= 10)

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
    local ret = {}
    local seen = {}
    for _, v in ipairs(list) do
        if not seen[v] then
            table.insert(ret, v)
            seen[v] = true
        end
    end
    return ret
end

---@param opts? {level?: number}
function M.pretty_trace(opts)
    opts = opts or {}
    -- local Config
    local trace = {}
    local level = opts.level or vim.log.levels.INFO

    while true do
        local info debug.getinfo(level, 'Sln')
        if not info then
            break
        end

        if info.what ~= 'C' then
            local source = info.source:sub(2)
            source = vim.fn.fnamemodify(source, ':p:~:.') --[[@as string]]
            local line = '  - ' .. source .. ':' .. info.currentline
            if info.name then
                line = line .. ' _in_ **' .. info.name .. '**'
            end
            table.insert(trace, line)
        end

        level = level + 1
    end

    return #trace > 0 and ('\n\n# stacktrace:\n' .. table.concat(trace, '\n')) or ''
end

---@alias MochiNotifyOpts {lang?: string, title?: string, level?: number, once?: boolean, stacktrace?: boolean, stacklevel?: number}

---@param msg string | string[]
---@param opts? MochiNotifyOpts
function M.notify(msg, opts)
    if vim.in_fast_event() then
        return vim.schedule(function()
            M.notify(msg, opts)
        end)
    end

    opts = opts or {}
    opts.level = opts.level or vim.log.levels.INFO
    opts.title = opts.title or 'Mochi'

    if type(msg) == 'table' then
        msg = table.concat(
            vim.tbl_filter(function(line)
                return line or false
            end, msg),
            '\n'
        )
    end

    if opts.stacktrace then
        msg = msg .. M.pretty_trace({ lavel = opts.stacklevel or vim.log.levels.INFO })
    end

    local lang = opts.lang or 'markdown'
    local notify = opts.once and vim.notify_once or vim.notify
    notify(msg, opts.level, {
        on_open = function(win)
            local ok = pcall(function()
                vim.treesitter.language.add('markdown')
            end)
            if not ok then
                pcall(require, 'nvim-treesitter')
            end

            -- https://neovim.io/doc/user/options.html#'conceallevel'
            vim.wo[win].conceallevel = 3
            vim.wo[win].concealcursor = ''
            vim.wo[win].spell = false

            local buf = vim.api.nvim_win_get_buf(win)
            if not pcall(vim.treesitter.start, buf, lang) then
                vim.bo[buf].filetype = lang
                vim.bo[buf].syntax = lang
            end
        end,
        title = opts.title,
    })
end

---@param msg string | string[]
---@param opts? MochiNotifyOpts
function M.log(msg, opts)
    M.notify(msg, opts)
end

---@param msg string | string[]
---@param opts? MochiNotifyOpts
function M.info(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.INFO
    M.notify(msg, opts)
end

---@param msg string | string[]
---@param opts? MochiNotifyOpts
function M.warn(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.WARN
    M.notify(msg, opts)
end

---@param msg string | string[]
---@param opts? MochiNotifyOpts
function M.error(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.ERROR
    M.notify(msg, opts)
end

---@generic R
---@param fn fun(): R?
---@param opts? string | {msg: string, on_error: fun(msg)}
---@return R?
function M.try(fn, opts)
    opts = type(opts) == 'string' and { msg = opts } or opts or {}
    local msg = opts.msg

    -- error handler
    local error_handler = function(err)
        msg = (msg and (msg .. '\n\n') or '') .. err .. M.pretty_trace()
        if opts.on_error then
            opts.on_error(msg)
        else
            vim.schedule(function()
                M.error(msg)
            end)
        end
        return err
    end

    ---@type boolean, any
    local ok, result = xpcall(fn, error_handler)
    return ok and result or nil
end

---@param t table
---@return boolean
function M.is_list(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end

-- check if table is not a list
---@return boolean
local function can_merge(v)
    return type(v) == 'table' and (vim.tbl_isempty(v) or not M.is_list(v))
end

---@generic T
---@param ... T
---@return T
function M.merge(...)
    local ret = select(1, ...)
    if ret == vim.NIL then
        return nil
    end

    for i = 2, select('#', ...) do
        local value = select(i, ...)
        if can_merge(ret) and can_merge(value) then
            for k, v in pairs(value) do
                ret[k] = M.merge(ret[k], v)
            end
        elseif value == vim.NIL then
            ret = nil
        elseif value ~= nil then
            ret = value
        end
    end

    return ret
end

function M.list_extend(...)
    local ret = select(1, ...)
    if ret == vim.NIL or not M.is_list(ret) then
        return nil
    end

    for i = 2, select('#', ...) do
        local value = select(i, ...)
        if M.is_list(value) then
            for _, v in ipairs(value) do
                ret[#ret + 1] = v
            end
        else
            return nil
        end
    end

    return ret
end

return M
