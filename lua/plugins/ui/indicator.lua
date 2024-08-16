local highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
}

local exclude_ft = {
    'help',
    'alpha',
    'neo-tree',
    'Trouble',
    'trouble',
    'lazy',
    'mason',
    'notify',
    'toggleterm',
}

return {
    -- indent indicatior
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'LazyFile',
        opts = {
            scope = { highlight = highlight },
            exclude = { filetypes = exclude_ft },
        },
        config = function(_, opts)
            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
                vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
                vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
                vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
                vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
                vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
                vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
            end)

            require('ibl').setup(opts)

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end
    },

    -- rainbow brackets
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = 'LazyFile',
        opts = {
            highlight = highlight,
            blacklist = exclude_ft,
        },
        config = function(_, opts)
            require('rainbow-delimiters.setup').setup(opts)
        end
    },
}
