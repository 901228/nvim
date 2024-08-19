return {
    -- to indicate buffers
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = 'VeryLazy',
        keys = {
            { '<leader>bd', function() Util.ui.bufremove() end, desc = 'Close Buffer' },
            { '<C-h>', '<CMD>BufferLineCyclePrev<CR>', desc = 'Prev Buffer' },
            { '<C-l>', '<CMD>BufferLineCycleNext<CR>', desc = 'Next Buffer' },
            { '<leader>bh', '<CMD>BufferLineMovePrev<CR>', desc = 'Move Buffer Prev' },
            { '<leader>bl', '<CMD>BufferLineMoveNext<CR>', desc = 'Move Buffer Next' },
        },
        opts = {
            options = {
                -- 使用 nvim 内置 lsp
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diagnostics_dict)
                    local str = ''
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
                        str = str .. ' ' .. sym .. n
                    end
                    return vim.trim(str)
                end,

                -- 左侧让出 neo-tree 的位置
                offsets = {
                    {
                        filetype = 'neo-tree',
                        text = 'File Explorer',
                        highlight = 'Directory',
                        text_align = 'left'
                    }
                },

                numbers = 'buffer_id',
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                show_tab_indicators = true,
                always_show_bufferline = true,
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = {'close'}
                },

                right_mouse_command = nil,
                middle_mouse_command = function(n) Util.ui.bufremove(n) end,
                close_command = function(n) Util.ui.bufremove(n) end,
            }
        },
        config = function(_, opts)
            require('bufferline').setup(opts)

            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
                callback = function()
                    vim.schedule(function()
                        pcall(nvim_bufferline)
                    end)
                end,
            })
        end,
    },

    -- window status line & buffer name
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = 'VeryLazy',
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            local colors = Util.colors

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
                file_status = false,
                newfile_status = true,
                path = 0,
                color = {
                    fg = colors.white,
                    bg = colors.lightGrey,
                },
                separator = { left = '  ', right = '  ' },
            }

            local navic = require('nvim-navic')
            local navic_bar = {
                'navic',
                color = {
                    fg = colors.white,
                    bg = colors.transparent,
                },
                color_correction = nil,
                navic_opts = nil,
            }

            local function default_name(name)
                return {
                    '\'' .. name .. '\'',
                    separator = { left = ' ', right = '' },
                    padding = 1,
                    icons_enabled = false,
                }
            end

            local custom_extensions = {
                neo_tree = {
                    sections = {
                        lualine_a = { default_name('NeoTree') },
                    },
                    filetypes = { 'neo-tree' },
                },
                toggleterm = {
                    sections = {
                        lualine_a = { default_name('ToggleTerm') },
                    },
                    filetypes = { 'toggleterm' }
                },
                telescope = {
                    sections = {
                        lualine_a = { default_name('Telescope') },
                    },
                    filetypes = { 'TelescopePrompt' }
                },
                alpha = {
                    sections = {
                        -- lualine_a = { default_name('Alpha') },
                    },
                    filetypes = { 'alpha' },
                },
                oil = {
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
                },
                trouble = {
                    sections = {
                        lualine_a = { default_name('Trouble') },
                    },
                    winbar = {
                        lualine_z = {},
                    },
                    filetypes = { 'Trouble' },
                },
            }

            return {
                options = {
                    theme = bubbles_theme,
                    component_separators = '|',
                    section_separators = { right = '', left = '' },
                    disabled_filetypes = { winbar = { 'neo-tree', 'alpha', 'oil' } },
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
                    lualine_c = {
                        { 'fileformat', separator = { right = '' } },
                        {
                            require('noice').api.status.command.get,
                            cond = require('noice').api.status.command.has,
                            color = { fg = '#ff9e64' },
                        },
                        {
                            require('noice').api.status.mode.get,
                            cond = require('noice').api.status.mode.has,
                            color = { fg = '#ff9e64' },
                        },
                    },
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
                    lualine_c = { navic_bar },
                    lualine_z = { win_bar_filename },
                },
                inactive_winbar = {
                    lualine_z = { win_bar_filename },
                },
            }
        end,
    },
}
