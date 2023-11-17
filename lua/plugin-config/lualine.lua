local colors = require('utils').colors

local bubbles_theme = {
    normal = {
        a = { fg = colors.darkGrey, bg = colors.lightBlue },
        b = { fg = colors.white, bg = colors.lightGrey },
        c = { fg = colors.white, bg = colors.transparent },
    },

    insert = { a = { fg = colors.darkGrey, bg = colors.green } },
    visual = { a = { fg = colors.darkGrey, bg = colors.violet } },
    replace = { a = { fg = colors.darkGrey, bg = colors.coral } },

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
        disabled_filetypes = { 'packer', 'NvimTree' }
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
