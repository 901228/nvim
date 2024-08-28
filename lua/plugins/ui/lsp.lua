return {
    -- navigation bar of functions
    {
        'SmiteshP/nvim-navic',
        opts = {
            icons = {
                File = '󰈙 ',
                Module = ' ',
                Namespace = '󰌗 ',
                Package = ' ',
                Class = '󰌗 ',
                Method = '󰆧 ',
                Property = ' ',
                Field = ' ',
                Constructor = ' ',
                Enum = '󰕘',
                Interface = '󰕘',
                Function = '󰊕 ',
                Variable = '󰆧 ',
                Constant = '󰏿 ',
                String = '󰀬 ',
                Number = '󰎠 ',
                Boolean = '◩ ',
                Array = '󰅪 ',
                Object = '󰅩 ',
                Key = '󰌋 ',
                Null = '󰟢 ',
                EnumMember = ' ',
                Struct = '󰌗 ',
                Event = ' ',
                Operator = '󰆕 ',
                TypeParameter = '󰊄 ',
            },
            lsp = {
                auto_attach = false,
                preference = nil,
            },
            highlight = false,
            separator = ' > ',
            depth_limit = 0,
            depth_limit_indicator = '..',
            safe_output = true,
            lazy_update_context = false,
            click = false,
            format_text = function(text) return text end,
        },
    },

    -- color highlighter
    {
        'NvChad/nvim-colorizer.lua',
        opts = {
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
            },
        },
    },
}
