require('lazy').setup({
    spec = {
        { import = 'Mochi.plugins.ui' },
        { import = 'Mochi.plugins' },
        { import = 'Mochi.plugins.editor' },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    -- install
    checker = {
        enabled = false,
        notify = false,
    },
})
