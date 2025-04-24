return {
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        ---@type CatppuccinOptions
        opts = {
            flavour = 'mocha',
            transparent_background = false,
            show_end_of_buffer = false,
            dim_inactive = { enabled = true },

            -- custom colors
            styles = {},
            color_overrides = {
                latte = Util.color.latte,
                frappe = Util.color.frappe,
                macchiato = Util.color.macchiato,
                mocha = Util.color.mocha,
            },
            custom_highlights = function(colors)
                return {
                    -- trailing symbols
                    NonText = { fg = '#0000FF' },
                }
            end,

            -- integrations
            default_integrations = true,
            integrations = {
                alpha = true,
                blink_cmp = true,
                flash = true,
                grug_far = true,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                    -- colored_indent_levels = true,
                },
                lsp_trouble = true,
                mason = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { 'undercurl' },
                        hints = { 'undercurl' },
                        warnings = { 'undercurl' },
                        information = { 'undercurl' },
                    },
                },
                navic = {
                    enabled = true,
                    custom_bg = 'lualine',
                },
                neotree = true,
                noice = true,
                notify = true,
                rainbow_delimiters = true,
                telescope = { enabled = true },
                treesitter = true,
                treesitter_context = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require('catppuccin').setup(opts)
            vim.cmd.colorscheme('catppuccin')
        end,
    },

    -- sync terminal background color with nvim colorscheme
    {
        'typicode/bg.nvim',
        lazy = false,
    },
}
