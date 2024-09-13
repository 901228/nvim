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

    -- comment lines or blocks
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {},
        config = function(_, opts)
            opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            require('Comment').setup(opts)
        end,
    },

    -- able to manipulate surround brackets or something
    {
        'echasnovski/mini.surround',
        keys = function(_, keys)
            local opts = Util.plugin.opts('mini.surround')
            local mappings = {
                { opts.mappings.add, desc = 'Add Surround', mode = { 'n', 'v' } },
                { opts.mappings.delete, desc = 'Delete Surround' },
                { opts.mappings.find, desc = 'Find Right Surround' },
                { opts.mappings.find_left, desc = 'Find Left Surround' },
                { opts.mappings.highlight, desc = 'Highlight Surround' },
                { opts.mappings.replace, desc = 'Replace Surround' },
                { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
                { 's', '', desc = '+ Surround' },
            }
            mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = 'sa',
                delete = 'sd',
                find = 'sf',
                find_left = 'sF',
                highlight = 'sh',
                replace = 'sr',
                update_n_lines = 'sn',
            },
        },
    },
}
