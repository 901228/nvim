local M = {}

local function default_name(name)
    return {
        '\'' .. name .. '\'',
        separator = { left = ' ', right = '' },
        padding = 1,
        icons_enabled = false,
    }
end

M.neo_tree = {
    sections = {
        lualine_a = { default_name('NeoTree') },
    },
    filetypes = { 'neo-tree' },
}

M.toggleterm = {
    sections = {
        lualine_a = { default_name('ToggleTerm') },
    },
    filetypes = { 'toggleterm' }
}

M.telescope = {
    sections = {
        lualine_a = { default_name('Telescope') },
    },
    filetypes = { 'TelescopePrompt' }
}

M.alpha = {
    sections = {
        -- lualine_a = { default_name('Alpha') },
    },
    filetypes = { 'alpha' },
}

M.oil = {
    sections = {
        lualine_a = {
            {
                [['Oil']],
                separator = { left = ' ', right = '' },
                padding = 1,
                icons_enabled = false,
            },
        },
        lualine_z = {{ 'mode', separator = { left = '', right = ' ' }, padding = 1 }},
    },
    filetypes = { 'oil' },
}

M.trouble = {
    sections = {
        lualine_a = { default_name('Trouble') },
    },
    winbar = {
        lualine_z = {},
    },
    filetypes = { 'Trouble' },
}

return M
