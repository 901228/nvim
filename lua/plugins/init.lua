Util.init()

return {
    { 'folke/lazy.nvim', version = '*' },
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'MunifTanjim/nui.nvim', lazy = true },

    -- view many things in a panel
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.4',
        dependencies = 'nvim-lua/plenary.nvim'
    },

    ---- UI ----
    -- enhance some searching funcitons
    -- use 'folke/flash.nvim'
    -- quick look of f/F word moving
    {
        'jinh0/eyeliner.nvim',
        config = function()
            require('eyeliner').setup({
                highlight_on_key = true,
                dim = true,
            })
        end
    },

    ---- Miscellaneous ----
    -- show keymaps
    {
        "folke/which-key.nvim",
        opts = {
            triggers = {
                { '<leader>', mode = { 'n', 'v' } },
                { 's', mode = { 'n', 'v' } },
                { 'g', mode = { 'n', 'v' } },
            },
        },
        config = function(_, opts)
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup(opts)
        end,
    },
}
