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

M.find_item = function(item, arr)
    for _, v in pairs(arr) do
        if v == item then
            return true
        end
    end
    return false
end

--TODO: add OS detect functions
M.os = {
    is_windows = function ()
        return vim.fn.has("win32") == 1
    end,
    is_linux = function()
        return vim.fn.has("win32") == 0
    end,
}

M.is_version_10 = (tonumber(vim.version().minor) >= 10)

M.setup_diagnostics_icon = function()
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

return M
