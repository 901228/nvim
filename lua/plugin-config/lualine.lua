local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
    lightBlue = '#a6bcff'
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white, bg = colors.black },
    },

    insert = { a = { fg = colors.black, bg = colors.lightBlue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white, bg = colors.black },
    },
}

require('lualine').setup {
    options = {
        theme = bubbles_theme,
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {
            { 'mode', separator = { left = ' ', right = '' }, padding = 1 },
        },
        lualine_b = {
            {
                'filename',
                newfile_status = true,
                symbols = {
                    modified = '[+]',      -- Text to show when the file is modified.
                    readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                    -- unnamed = '[No Name]', -- Text to show for unnamed buffers.
                    unnamed = '[]', -- Text to show for unnamed buffers.
                    -- newfile = '[New]',     -- Text to show for newly created file before first write
                    newfile = '[]',     -- Text to show for newly created file before first write
                },
            },
            'branch',
        },
        lualine_c = { { 'fileformat', separator = { right = '' } } },
        lualine_x = {
            { 'diagnostics', sources = { 'nvim_lsp' } },
        },
        lualine_y = {
            {
                'filetype',
                colored = true,
            },
            { 'progress', padding = 1 }
        },
        lualine_z = {
            { 'location', separator = { left = '', right = ' ' }, padding = { right = 1 } },
        },
    },
    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'filetype' },
        lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {},
}
