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
    command = {},
    inactive = {},
}

local win_bar_filename = {
    'filename',
    newfile_status = true,
    path = 0,
    symbols = {
        modified = '[+]',
        readonly = '[-]',
        unnamed = '[]', 
        newfile = '[]', 
    },
    color = {
        fg = colors.white,
        bg = colors.lightGrey,
    },
    separator = { left = '  ', right = '  ' },
}

local custom_extensions = require('plugin-config/lualine_extensions')

require('lualine').setup {
    options = {
        theme = bubbles_theme,
        component_separators = '|',
        section_separators = { right = '', left = '' },
        disabled_filetypes = { winbar = { 'packer', 'NvimTree' } },
        globalstatus = true,
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
            {
                'branch',
                separator = { right = '' },
                padding = 1,
            },
        },
        lualine_c = { { 'fileformat', separator = { right = '' } } },
        lualine_x = {
            {
                'diagnostics',
                sources = { 'nvim_lsp' },
                colored = true,
            },
        },
        lualine_y = {
            {
                'filetype',
                colored = true,
                separator = { left = '' },
                padding = 1,
            },
            { 'progress', padding = 1 }
        },
        lualine_z = {
            { 'location', separator = { left = '', right = ' ' }, padding = { right = 1 } },
        },
    },
    inactive_section = {
        lualine_a = { 'filename' },
        lualine_y = { 'filetype' },
        lualine_z = { 'location' },
    },
    tabline = {},
    extensions = custom_extensions,
    winbar = {
        lualine_z = { win_bar_filename },
    },
    inactive_winbar = {
        lualine_z = { win_bar_filename },
    },
}
