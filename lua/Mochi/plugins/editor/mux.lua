return {
    {
        'mrjones2014/smart-splits.nvim',
        opts = {},
        config = function(_, opts)
            require('smart-splits').setup(opts)

            Util.keymap(
                'n',
                '<A-h>',
                function() require('smart-splits').move_cursor_left() end,
                { icon = '󰞗' },
                'Move Left'
            )
            Util.keymap(
                'n',
                '<A-j>',
                function() require('smart-splits').move_cursor_down() end,
                { icon = '󰞖' },
                'Move Down'
            )
            Util.keymap(
                'n',
                '<A-k>',
                function() require('smart-splits').move_cursor_up() end,
                { icon = '󰞙' },
                'Move Up'
            )
            Util.keymap(
                'n',
                '<A-l>',
                function() require('smart-splits').move_cursor_right() end,
                { icon = '󰞘' },
                'Move Right'
            )

            -- TODO: other APIs ?
        end,
    },
}
