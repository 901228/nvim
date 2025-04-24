Util.init()

return {
    { 'folke/lazy.nvim', version = '*' },

    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'MunifTanjim/nui.nvim', lazy = true },

    {
        'folke/which-key.nvim',
        events = 'VeryLazy',
        dependencies = {
            'echasnovski/mini.icons',
        },
        opts_extend = { 'spec' },
        ---@class wk.Opts
        opts = {
            icons = {
                -- group = ' ',
                group = '',
            },
            triggers = {
                { '<leader>', mode = { 'n', 'v' } },
                { 's', mode = { 'n', 'v' } },
                { 'g', mode = { 'n', 'v' } },
                { 'z', mode = { 'n', 'v' } },
                { '[', mode = { 'n', 'v' } },
                { ']', mode = { 'n', 'v' } },
            },
        },
        config = function(_, opts)
            vim.o.timeout = true
            vim.o.timeoutlen = 300

            require('which-key').setup(opts)

            Util.keymap('n', '<leader>w', '<CMD>w<CR>', { icon = '󰆓' }, 'Save')
            Util.keymap('n', '<leader>q', '<CMD>q<CR>', { icon = '󰅖' }, 'Quit')

            -- Lazy
            Util.keymap('n', '<leader>l', '<CMD>Lazy<CR>', {}, 'Lazy')

            -- lang utils
            Util.keymap.key_group(
                '<leader>h',
                'Lang Utils',
                { icon = require('mini.icons').get('filetype', vim.bo.filetype) }
            )

            -- clear search and stop snippet on escape
            Util.keymap({ 'i', 'n', 's' }, '<ESC>', function()
                vim.cmd('noh')
                Util.cmp.actions.snippet_stop()
                return '<ESC>' ---@diagnostic disable-line: redundant-return-value
            end, { expr = true, icon = '󱊷' }, ' Escape and Clear hlsearch')
        end,
    },
}
