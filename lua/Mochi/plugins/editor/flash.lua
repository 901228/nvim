return {
    -- enhance some searching functions
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {},
        -- stylua: ignore
        init = function()
            Util.keymap.key_group('<leader>s', 'Flash', { icon = '󰉁' })
        end,
        keys = {
            -- { '<leader>s', '', desc = 'Flash' },
            { '<leader>ss', function() require('flash').jump() end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
            { '<leader>sS', function() require('flash').treesitter() end, mode = { 'n', 'x', 'o' }, desc = 'Flash Treesitter' },
            { 'r', function() require('flash').remote() end, mode = 'o', desc = 'Remote Flash' },
            { 'R', function() require('flash').treesitter_search() end, mode = { 'o', 'x' }, desc = 'Tresitter Search' },
        },
    },
}
