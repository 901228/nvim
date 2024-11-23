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
        event = 'LazyFile',
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
                css = true,
                css_fn = true,
                tailwind = false,
                sass = { enable = true, parsers = { 'css' } },

                -- display
                mode = 'virtualtext',
                virtualtext = ' ',

                always_update = false,
            },
        },
    },

    -- to trim whitespaces
    {
        'johnfrankmorgan/whitespace.nvim',
        event = 'LazyFile',
        keys = {
            {
                '<leader>k',
                function()
                    local ok, whitespace = pcall(require, 'whitespace-nvim')
                    if ok then
                        whitespace.trim()
                    end
                end,
                desc = 'trim whitespaces',
            },
        },
        opts = {
            ignored_filetypes = Util.plugin.non_editor_ft,
        },
    },
}
