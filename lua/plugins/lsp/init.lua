local M = {}

M = Util.list_extend(
    M,
    require('plugins.lsp.treesitter'),
    require('plugins.lsp.lsp'),
    require('plugins.lsp.util'),
    require('plugins.lsp.cmp'),
    require('plugins.lsp.langs')
)

-- formatting
require('lsp.formatting')

return M
