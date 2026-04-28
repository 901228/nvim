---@class MochiUtil.menus
local M = {}

M.default = {
    {
        name = 'Format Buffer',
        cmd = function() Util.format() end,
        rtxt = '<leader>i',
    },
    {
        name = 'Code Actions',
        cmd = require('clear-action.actions').code_action,
        rtxt = 'ga',
    },
    { name = 'separator' },

    {
        name = '  Lsp Actions',
        hl = 'Exblue',
        items = 'lsp',
    },
    { name = 'separator' },

    {
        name = 'Copy to Clipboard',
        cmd = 'normal! gv"+y',
    },
    { name = 'separator' },

    {
        name = '  Color Picker',
        cmd = function() require('minty.huefy').open() end,
    },
}

return M
