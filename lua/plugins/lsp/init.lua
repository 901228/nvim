local M = {}

M = Util.list_extend(
    M,
    require('plugins.lsp.treesitter'),
    require('plugins.lsp.langs'),
    require('plugins.lsp.lsp'),
    require('plugins.lsp.util')
)

-- cmp
require('lsp.cmp')

-- formatting
require('lsp.formatting')

return M
