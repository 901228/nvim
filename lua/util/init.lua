local M = {}

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

function M.setup_diagnostics_icon()
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

    if M.is_version_10 then
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = signs.Error,
                    [vim.diagnostic.severity.WARN] = signs.Warn,
                    [vim.diagnostic.severity.HINT] = signs.Hint,
                    [vim.diagnostic.severity.INFO] = signs.Info,
                },
                linehl = {
                    [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                    [vim.diagnostic.severity.WARN] = 'WarnMsg',
                    [vim.diagnostic.severity.HINT] = 'HintMsg',
                    [vim.diagnostic.severity.INFO] = 'InfoMsg',
                },
                numhl = {
                    [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                    [vim.diagnostic.severity.WARN] = 'WarnMsg',
                    [vim.diagnostic.severity.HINT] = 'HintMsg',
                    [vim.diagnostic.severity.INFO] = 'InfoMsg',
                },
            },
        })
    else
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl })
        end
    end
end

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

---@param msg string
---@param opts table?
function M.log(msg, opts)
    local _opts = opts or {}
    _opts.title = _opts.title or 'Notification'

    vim.notify(msg, _opts.level, opts)
end

---@param msg string
---@param opts table?
function M.notify(msg, opts)
    M.log(msg, opts)
end

---@param msg string
---@param title string?
function M.info(msg, title)
    local opts = {
        level = vim.log.levels.INFO,
        title = title,
    }
    M.log(msg, opts)
end

---@param msg string
---@param title string?
function M.warn(msg, title)
    local opts = {
        level = vim.log.levels.WARN,
        title = title,
    }
    M.log(msg, opts)
end

---@param msg string
---@param title string?
function M.error(msg, title)
    local opts = {
        level = vim.log.levels.ERROR,
        title = title,
    }
    M.log(msg, opts)
end

-- M = vim.tbl_deep_extend('error',
--     M,
--     require('util.plugin'),
--     require('util.ui'),
--     require('util.path')
-- )

require('util.path').path.lsmod('lua.util', function(mod)
    M = vim.tbl_deep_extend('error', M, require(mod))
end)

return M
