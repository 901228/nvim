local M = {}

M = Util.list_extend(
    M,
    require('Mochi.plugins.lsp.treesitter'),
    require('Mochi.plugins.lsp.lsp'),
    require('Mochi.plugins.lsp.util'),
    require('Mochi.plugins.lsp.lint'),
    require('Mochi.plugins.lsp.cmp'),
    require('Mochi.plugins.lsp.format'),
    require('Mochi.plugins.lsp.langs'),
    require('Mochi.plugins.lsp.ai')
)

return M
