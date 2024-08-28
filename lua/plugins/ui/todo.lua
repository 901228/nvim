return {
    -- todo highlight
    {
        'folke/todo-comments.nvim',
        dependencies = {
            'plenary.nvim',
            'trouble.nvim',
            'telescope.nvim',
        },
        cmd = { 'TodoTrouble', 'TodoTelescope' },
        event = 'LazyFile',
        opts = {},
        keys = {
            { ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment' },
            { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment' },
            { '<leader>xt', '<CMD>Trouble todo toggle<CR>', desc = 'Todo' },
            { '<leader>ft', '<CMD>TodoTelescope<CR>', desc = 'Todo' },
        },
    },
}
