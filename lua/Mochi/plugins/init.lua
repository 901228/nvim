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

            -- move between windows(panes)
            -- Util.keymap('n', '<A-h>', '<C-w>h', { icon = '󰞗' }, 'Move Left')
            -- Util.keymap('n', '<A-j>', '<C-w>j', { icon = '󰞖' }, 'Move Down')
            -- Util.keymap('n', '<A-k>', '<C-w>k', { icon = '󰞙' }, 'Move Up')
            -- Util.keymap('n', '<A-l>', '<C-w>l', { icon = '󰞘' }, 'Move Right')

            -- Lazy
            Util.keymap('n', '<leader>l', '<CMD>Lazy<CR>', {}, 'Lazy')

            -- lang utils
            Util.keymap.key_group(
                '<leader>h',
                'Lang Utils',
                { icon = require('mini.icons').get('filetype', vim.bo.filetype) }
            )
        end,
    },
}
