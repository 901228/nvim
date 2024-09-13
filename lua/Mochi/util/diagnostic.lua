---@class MochiUtil.diagnostic
local M = {}

---@alias diagnostic.icons { Error: string, Warn: string, Hint: string, Info: string }

---@type diagnostic.icons
M.icons = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
}

---@param icons? diagnostic.icons
function M.setup9(icons)
    icons = icons or M.icons
    for type, icon in pairs(icons) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end
end

---@param icons? diagnostic.icons
function M.setup10(icons)
    icons = icons or M.icons
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = icons.Error,
                [vim.diagnostic.severity.WARN] = icons.Warn,
                [vim.diagnostic.severity.HINT] = icons.Hint,
                [vim.diagnostic.severity.INFO] = icons.Info,
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
end

---@param icons? diagnostic.icons
function M.setup(icons)
    if Util.is_version_10 then
        M.setup10(icons)
    else
        M.setup9(icons)
    end
end

return M
