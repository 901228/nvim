local M = {}

local function default_name(name)
    return {
        '\'' .. name .. '\'',
        separator = { left = ' ', right = '' },
        padding = 1,
        icons_enabled = false,
    }
end

M.nvim_tree = {
    sections = {
        lualine_a = { default_name('NvimTree') },
    },
    filetypes = { 'NvimTree' },
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

return M
