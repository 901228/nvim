Util.init()

return {
    { 'folke/lazy.nvim', version = '*' },

    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'MunifTanjim/nui.nvim', lazy = true },

    {
        'folke/which-key.nvim',
        opts = {
            triggers = {
                { '<leader>', mode = { 'n', 'v' } },
                { 's', mode = { 'n', 'v' } },
                { 'g', mode = { 'n', 'v' } },
                { 'z', mode = { 'n', 'v' } },
            },
        },
        config = function(_, opts)
            vim.o.timeout = true
            vim.o.timeoutlen = 300

            require('which-key').setup(opts)
        end,
    },
}
