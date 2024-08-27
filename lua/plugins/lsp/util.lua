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
    },
    {
        'noice.nvim',
        opts = {
            presets = { inc_rename = true },
        },
    },

    -- auto add brackets or something in pair
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
            enable_check_bracket_line = true,
            ignored_text_char = '[%w%.]',
        },
    },
}
