return {
    -- code action
    {
        'luckasRanarison/clear-action.nvim',
        event = 'LazyFile',
        opts = {},
    },

    -- guess the indentation of the file
    {
        'NMAC427/guess-indent.nvim',
        event = 'LazyFile',
        opts = {},
    },

    -- rename
    {
        'smjonas/inc-rename.nvim',
        cmd = 'IncRename',
        opts = {},
        config = function(_, opts)
            require('inc_rename').setup(opts)
        end,
    },
}
