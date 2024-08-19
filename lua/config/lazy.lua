
require('lazy').setup({
    spec = {
        { import = 'plugins' },
        { import = 'plugins.ui' },
        { import = 'plugins.editor' },
        -- { import = 'plugins.lsp' },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    -- install
    checker = {
        enabled = true,
        notify = true,
    },
})
