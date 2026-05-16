return {
    -- search/replace in multiple files with ui
    {
        'MagicDuck/grug-far.nvim',
        opts = { headerMaxWidth = 80 },
        cmd = 'GrugFar',
        keys = {
            {
                '<leader>sr',
                function()
                    local grug = require('grug-far')
                    local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                        },
                    })
                end,
                mode = { 'n', 'v' },
                desc = 'Search and Replace',
            },
        },
    },

    {
        '2kabhishek/nerdy.nvim',
        dependencies = {
            'stevearc/dressing.nvim',
            'nvim-telescope/telescope.nvim',
        },
        cmd = 'Nerdy',
    },

    {
        'rubiin/highlighturl.nvim',
        init = function() vim.g.highlighturl = true end,
    },

    -- write readonly file
    {

        'alex-k03/sudo-write.nvim',
        keys = {
            { '<leader>bS', function() require('sudo-write').write() end, mode = 'n', desc = 'Sudo force save' },
        },
    },
}
