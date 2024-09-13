require('lazy').setup({
    spec = {
        { import = 'Mochi.plugins' },
        { import = 'Mochi.plugins.ui' },
        { import = 'Mochi.plugins.editor' },
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
