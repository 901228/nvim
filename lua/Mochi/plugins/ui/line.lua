return {
    -- to indicate buffers
    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'catppuccin',
        },
        event = 'VeryLazy',
        keys = {
            -- { '<leader>b', '', desc='Buffers' },
            { '<leader>bd', function() Util.ui.bufremove() end, desc = 'Close Buffer' },
            { '<C-h>', '<CMD>BufferLineCyclePrev<CR>', desc = 'Prev Buffer' },
            { '<C-l>', '<CMD>BufferLineCycleNext<CR>', desc = 'Next Buffer' },
            { '<leader>bh', '<CMD>BufferLineMovePrev<CR>', desc = 'Move Buffer Prev' },
            { '<leader>bl', '<CMD>BufferLineMoveNext<CR>', desc = 'Move Buffer Next' },
        },
        opts = {
            options = {
                -- 使用 nvim 内置 lsp
                diagnostics = 'nvim_lsp',
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
                        text_align = 'left',
                    },
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
                    reveal = { 'close' },
                },

                right_mouse_command = nil,
                middle_mouse_command = function(n) Util.ui.bufremove(n) end,
                close_command = function(n) Util.ui.bufremove(n) end,
            },
        },
        config = function(_, opts)
            opts = vim.tbl_extend(
                'force',
                opts,
                { highlights = require('catppuccin.groups.integrations.bufferline').get() }
            )
            require('bufferline').setup(opts)

            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
                callback = function()
                    vim.schedule(function() pcall(nvim_bufferline) end)
                end,
            })

            Util.keymap.key_group('<leader>b', 'Buffers', { icon = '' })
        end,
    },

    -- window status line & buffer name
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = 'VeryLazy',
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = ' '
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            local win_bar_filename = {
                'filename',
                file_status = false,
                newfile_status = true,
                path = 0,
                separator = { left = '  ', right = '  ' },
            }

            ---@module 'navic'
            local navic_bar = {
                'navic',
                color_correction = nil,
                navic_opts = nil,
            }

            local venv_selector = require('lualine.component'):extend()
            function venv_selector:init(options)
                options = vim.tbl_deep_extend('keep', options or {}, {
                    icon = '',
                    color = { fg = '#CDD6F4' },
                    on_click = function() vim.cmd([[VenvSelect]]) end,
                })
                venv_selector.super.init(self, options)
            end
            function venv_selector:update_status()
                if vim.bo.filetype == 'python' then
                    local venv = require('venv-selector').venv()
                    if venv ~= nil then
                        local venv_parts = vim.fn.split(venv, '/')
                        local venv_name = venv_parts[#venv_parts]
                        return venv_name
                    else
                        return 'Select Venv'
                    end
                else
                    return ''
                end
            end

            local function default_name(name)
                return {
                    "'" .. name .. "'",
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
                    filetypes = { 'toggleterm' },
                },
                telescope = {
                    sections = {
                        lualine_a = { default_name('Telescope') },
                    },
                    filetypes = { 'TelescopePrompt' },
                },
                alpha = {
                    sections = {},
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
                        lualine_z = { { 'mode', separator = { left = '', right = ' ' }, padding = 1 } },
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
                                modified = '[+]', -- Text to show when the file is modified.
                                readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
                                -- unnamed = '[No Name]', -- Text to show for unnamed buffers.
                                unnamed = '[]', -- Text to show for unnamed buffers.
                                -- newfile = '[New]',     -- Text to show for newly created file before first write
                                newfile = '[]', -- Text to show for newly created file before first write
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
                        venv_selector,
                        { 'progress', padding = 1 },
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
