require('colorizer').setup({
    filetypes = {
        '*',
        lua = { names = false },
    },
    user_default_options = {
        -- fn list
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = false,
        hsl_fn = false,
        css = false,
        css_fn = false,
        tailwind = false,
        sass = { enable = false, parsers = { 'css' } },

        -- display
        mode = 'virtualtext',
        virtualtext = ' ',

        always_update = false,
    }
})

